#import <Cocoa/Cocoa.h>
#import <CoreFoundation/CoreFoundation.h>
#import <CoreServices/CoreServices.h>
#import <Foundation/Foundation.h>
#import <QuickLook/QuickLook.h>

OSStatus GeneratePreviewForURL(void *thisInterface, QLPreviewRequestRef preview, CFURLRef url,
                               CFStringRef contentTypeUTI, CFDictionaryRef options);
void CancelPreviewGeneration(void *thisInterface, QLPreviewRequestRef preview);
NSString *WrapSVGForPreview(NSURL *url);

/* -----------------------------------------------------------------------------
   Generate a preview for file
   This function's job is to create preview for designated file
   -----------------------------------------------------------------------------
 */
OSStatus GeneratePreviewForURL(void *thisInterface, QLPreviewRequestRef preview, CFURLRef url,
                               CFStringRef contentTypeUTI, CFDictionaryRef options) {

  NSString *content = WrapSVGForPreview((__bridge NSURL *)url);

  CFDictionaryRef previewProperties = (__bridge CFDictionaryRef) @{
    (__bridge NSString *)kQLPreviewPropertyTextEncodingNameKey : @"UTF-8",
    (__bridge NSString *)kQLPreviewPropertyMIMETypeKey : @"text/html",
  };

  QLPreviewRequestSetDataRepresentation(preview, (__bridge CFDataRef)[content dataUsingEncoding:NSUTF8StringEncoding],
                                        kUTTypeHTML, previewProperties);

  return noErr;
}

void CancelPreviewGeneration(void *thisInterface, QLPreviewRequestRef preview) {
  // Implement only if supported
}

NSString *WrapSVGForPreview(NSURL *url) {
    NSError *error;
    NSString *content = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:&error];
    
    NSString *result = [NSString stringWithFormat:@"<html><head><style type=\"text/css\">html, body {background: #999; margin: 0px; padding: 0px; height: calc(100%% - 20px);} svg { display: block; border: 1px solid #aaa; margin: 5px; max-height: calc(100%% - 20px); max-width: calc(100%% - 10px); background-image: linear-gradient(45deg, #bbb 25%%, transparent 25%%), linear-gradient(-45deg, #bbb 25%%, transparent 25%%), linear-gradient(45deg, transparent 75%%, #bbb 75%%), linear-gradient(-45deg, transparent 75%%, #bbb 75%%);            background-size: 8px 8px; background-position: 0 0, 0 4px, 4px -4px, -4px 0px;}</style></head><body>%@</body></html>", content];
    
    return result;
}
