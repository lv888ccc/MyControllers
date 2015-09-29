/***************************************************************************
 *                                  _   _ ____  _
 *  Project                     ___| | | |  _ \| |
 *                             / __| | | | |_) | |
 *                            | (__| |_| |  _ <| |___
 *                             \___|\___/|_| \_\_____|
 *
 * Copyright (C) 1998 - 2011, Daniel Stenberg, <daniel@haxx.se>, et al.
 *
 * This software is licensed as described in the file COPYING, which
 * you should have received as part of this distribution. The terms
 * are also available at http://curl.haxx.se/docs/copyright.html.
 *
 * You may opt to use, copy, modify, merge, publish, distribute and/or sell
 * copies of the Software, and permit persons to whom the Software is
 * furnished to do so, under the terms of the COPYING file.
 *
 * This software is distributed on an "AS IS" basis, WITHOUT WARRANTY OF ANY
 * KIND, either express or implied.
 *
 ***************************************************************************/
/* Upload to FTP, resuming failed transfers
 *
 * Compile for MinGW like this:
 *  gcc -Wall -pedantic -std=c99 ftpuploadwithresume.c -o ftpuploadresume.exe
 *  -lcurl -lmsvcr70
 *
 * Written by Philip Bock
 */

#include <stdlib.h>
#include <stdio.h>
#include "ftpupload.h"

#if defined(_MSC_VER) && (_MSC_VER < 1300)
#  error _snscanf requires MSVC 7.0 or later.
#endif

//long Uploadlength= 0;
int g_stop_ftp_flag =0;
//上次上传的length
long uploaded_len = 0;

/* The MinGW headers are missing a few Win32 function definitions,
   you shouldn't need this if you use VC++ */
#if defined(__MINGW32__) && !defined(__MINGW64__)
int __cdecl _snscanf(const char * input, size_t length, const char * format, ...);
#endif



/* parse headers for Content-Length */
size_t getcontentlengthfunc(void *ptr, size_t size, size_t nmemb, void *stream)
{

  int r;
  long len = 0;

  /* _snscanf() is Win32 specific */
  r = sscanf((const char*)ptr, "Content-Length: %ld\n", &len);

  if (r) /* Microsoft: we don't read the specs */
    *((long *) stream) = len;
    
    return size * nmemb;
}

int getProgressValue(const char* flag,double t, double d, double ultotal, double ulnow){

   //printf("%s %g / %g (%g %%)\n",flag,d,t,d*100.0/t);

   // printf("upload %.2f%%\n",(ulnow+uploaded_len)*100/ultotal);
   // printf("upload now=%f last=%ld total=%f\n",ulnow,uploaded_len,ultotal);
    
    uploadProgress(ultotal,ulnow+uploaded_len);
    
    return 0;
}

/* discard downloaded data */
size_t discardfunc(void *ptr, size_t size, size_t nmemb, void *stream)
{
  return size * nmemb;
}

/* read data to upload */
size_t readfunc(void *ptr, size_t size, size_t nmemb, void *stream)
{
  FILE *f = (FILE*)stream;
  size_t n;

  if (ferror(f))
    return CURL_READFUNC_ABORT;
//printf("readfile %d\n",g_stop_ftp_flag);
  if (g_stop_ftp_flag==1) {
        return 0;
    }
  n = fread(ptr, size, nmemb, f) * size;

  return n;
}

int getFileSize(const char * strFileName)
{
    FILE * fp = fopen(strFileName, "r");
    fseek(fp, 0L, SEEK_END);
    int size = ftell(fp);
    fclose(fp);
    return size;
}

int upload(CURL *curlhandle, const char * remotepath, const char * localpath,
           long timeout, long tries)
{
  FILE *f;
//  long uploaded_len = 0;
  CURLcode r = CURLE_GOT_NOTHING;
  int c;
    g_stop_ftp_flag=0;
  f = fopen(localpath, "rb");
  if (f == NULL) {
    perror(NULL);
    return 0;
  }
   
  curl_easy_setopt(curlhandle, CURLOPT_UPLOAD, 1L);

  curl_easy_setopt(curlhandle, CURLOPT_URL, remotepath);

  if (timeout)
    curl_easy_setopt(curlhandle, CURLOPT_FTP_RESPONSE_TIMEOUT, timeout);

  curl_easy_setopt(curlhandle, CURLOPT_HEADERFUNCTION, getcontentlengthfunc);
  curl_easy_setopt(curlhandle, CURLOPT_HEADERDATA, &uploaded_len);

  curl_easy_setopt(curlhandle, CURLOPT_NOPROGRESS, 0);
  curl_easy_setopt(curlhandle, CURLOPT_PROGRESSFUNCTION,getProgressValue);
  curl_easy_setopt(curlhandle, CURLOPT_PROGRESSDATA, "progress");
      
  curl_easy_setopt(curlhandle, CURLOPT_WRITEFUNCTION, discardfunc);

  curl_easy_setopt(curlhandle, CURLOPT_READFUNCTION, readfunc);
  curl_easy_setopt(curlhandle, CURLOPT_READDATA, f);
  curl_easy_setopt(curlhandle, CURLOPT_INFILESIZE,getFileSize(localpath));

//  curl_easy_setopt(curlhandle, CURLOPT_FTPPORT, "-"); /* disable passive mode */
  curl_easy_setopt(curlhandle, CURLOPT_FTP_CREATE_MISSING_DIRS, 1L);

  curl_easy_setopt(curlhandle, CURLOPT_VERBOSE, 1L);

  for (c = 1; (r != CURLE_OK) && (c < tries); c++) {
    /* are we resuming? */
    if (c) { /* yes */
      /* determine the length of the file already written */

      /*
       * With NOBODY and NOHEADER, libcurl will issue a SIZE
       * command, but the only way to retrieve the result is
       * to parse the returned Content-Length header. Thus,
       * getcontentlengthfunc(). We need discardfunc() above
       * because HEADER will dump the headers to stdout
       * without it.
       */
      curl_easy_setopt(curlhandle, CURLOPT_NOBODY, 1L);
      curl_easy_setopt(curlhandle, CURLOPT_HEADER, 1L);
      curl_easy_getinfo(curlhandle,CURLINFO_CONTENT_LENGTH_UPLOAD,&uploaded_len);
      r = curl_easy_perform(curlhandle);
      if (r != CURLE_OK)
        continue;

      curl_easy_setopt(curlhandle, CURLOPT_NOBODY, 0L);
      curl_easy_setopt(curlhandle, CURLOPT_HEADER, 0L);

      fseek(f, uploaded_len, SEEK_SET);
        
      curl_easy_setopt(curlhandle, CURLOPT_APPEND, 1L);
    }
    else { /* no */
      curl_easy_setopt(curlhandle, CURLOPT_APPEND, 0L);
    }
    r = curl_easy_perform(curlhandle);
  }

  fclose(f);

  if (r == CURLE_OK)
    return 1;
  else {
    fprintf(stderr, "%s\n", curl_easy_strerror(r));
    return 0;
  }
}

void stopftpUpload(void)
{
    g_stop_ftp_flag=1;
}
/*
int main(int c, char **argv)
{
  CURL *curlhandle = NULL;

  curl_global_init(CURL_GLOBAL_ALL);
  curlhandle = curl_easy_init();

  upload(curlhandle, "ftp://duhuanbiao:duhuanbiao@10.0.0.7/test/123.tgz", "/home/bontec/curl-7.28.1/docs/examples/123.tgz",0, 3);

  curl_easy_cleanup(curlhandle);
  curl_global_cleanup();

  return 0;
}
*/