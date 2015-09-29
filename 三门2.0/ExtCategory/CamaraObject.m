//
//  CamaraObject.m
//  SanMen
//
//  Created by lcc on 13-12-27.
//  Copyright (c) 2013年 lcc. All rights reserved.
//

#import "CamaraObject.h"

@implementation CamaraObject

- (void) openPicOrVideoWithSign:(NSInteger) sign
{
    switch (sign)
    {
        case 0:
            //本地相簿
        {
            UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
            imagePicker.delegate = self.c_delegate;
            imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            imagePicker.mediaTypes =  [[NSArray alloc] initWithObjects: @"public.image", nil];
            [SMApp.nav presentModalViewController:imagePicker animated:YES];
        }
            break;
        case 1:
            //照相机
        {
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
                UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
                
                imagePicker.delegate = self.c_delegate;
                imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
                imagePicker.mediaTypes =  [[NSArray alloc] initWithObjects: @"public.image", nil];
                [SMApp.nav presentModalViewController:imagePicker animated:YES];
            }
        }
            break;
        default:
            break;
    }
}

@end
