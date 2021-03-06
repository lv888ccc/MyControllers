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
#ifndef __FTP_UPLOAD
#define __FTP_UPLOAD

#include "curl.h"

int upload(CURL *curlhandle, const char * remotepath, const char * localpath,
           long timeout, long tries);

extern void uploadProgress(double ultotal, double ulnow);
void stopftpUpload(void);
#endif