//
//  IVGHTMLExtractor.m
//  IVGUtils
//
//  Created by Douglas Sjoquist on 2/4/13.
//  Copyright (c) 2013 Ivy Gulch, LLC. All rights reserved.
//

#import "IVGHTMLExtractor.h"
#import "NSObject+IVGUtils.h"

#define AOKEY_ID_TO_EXTRACT @"idToExtract"
#define AOKEY_RETURN_BLOCK @"returnBlock"

@interface IVGHTMLExtractor()<UIWebViewDelegate>
@property (nonatomic,strong) NSMutableSet *webViews;
@end

@implementation IVGHTMLExtractor

#pragma mark - Life cycle methods

- (id) init;
{
    if ((self = [super init])) {
        _webViews = [[NSMutableSet alloc] init];
    }
    return self;
}

#pragma mark - extraction methods

- (UIWebView *) newExtractionWebViewWithExtractId:(NSString *) idToExtract returnBlock:(IVGHTMLReturnBlock) returnBlock;
{
    UIWebView *webView = [[UIWebView alloc] init];
    webView.delegate = self;
    [webView setAssociatedUserInfoObject:idToExtract forKey:AOKEY_ID_TO_EXTRACT];
    [webView setAssociatedUserInfoObject:returnBlock forKey:AOKEY_RETURN_BLOCK];
    [self.webViews addObject:webView];
    return webView;
}

- (void) extractId:(NSString *) idToExtract fromURL:(NSURL *) url withReturnBlock:(IVGHTMLReturnBlock) returnBlock;
{
    UIWebView *webView = [self newExtractionWebViewWithExtractId:idToExtract returnBlock:returnBlock];
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    [webView loadRequest:requestObj];
}

- (void) extractId:(NSString *) idToExtract fromHTML:(NSString *) html withReturnBlock:(IVGHTMLReturnBlock) returnBlock;
{
    UIWebView *webView = [self newExtractionWebViewWithExtractId:idToExtract returnBlock:returnBlock];
    [webView loadHTMLString:html baseURL:nil];
}

- (void) extractId:(NSString *) idToExtract fromData:(NSData *) data withReturnBlock:(IVGHTMLReturnBlock) returnBlock;
{
    UIWebView *webView = [self newExtractionWebViewWithExtractId:idToExtract returnBlock:returnBlock];
    [webView loadData:data MIMEType:@"text/html" textEncodingName:@"utf-8" baseURL:nil];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView;
{
    NSURL *url = [[webView request] URL];

    NSString *idToExtract = [webView associatedUserInfoObjectForKey:AOKEY_ID_TO_EXTRACT];
    NSString *js = [NSString stringWithFormat:@"document.getElementById('%@').innerHTML", idToExtract];
    NSString *html = [webView stringByEvaluatingJavaScriptFromString:js];

    IVGHTMLReturnBlock returnBlock = [webView associatedUserInfoObjectForKey:AOKEY_RETURN_BLOCK];
    returnBlock(url, idToExtract, html, nil);

    [self.webViews removeObject:webView];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error;
{
    NSURL *url = [[webView request] URL];

    NSString *idToExtract = [webView associatedUserInfoObjectForKey:AOKEY_ID_TO_EXTRACT];
    IVGHTMLReturnBlock returnBlock = [webView associatedUserInfoObjectForKey:AOKEY_RETURN_BLOCK];
    returnBlock(url, idToExtract, nil, error);

    [self.webViews removeObject:webView];
}


@end
