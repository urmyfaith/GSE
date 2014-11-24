//
//  DetectorView.m
//  FOXSI-GSE
//
//  Created by Steven Christe on 11/24/14.
//  Copyright (c) 2014 Steven Christe. All rights reserved.
//

#import "DetectorView.h"
#include <OpenGL/gl.h>

#define	XBORDER 5
#define YBORDER 5
#define XSTRIPS 128
#define YSTRIPS 128

@implementation DetectorView

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    [[self openGLContext] makeCurrentContext];
    
    glClearColor(0.0f, 0.0f, 0.0f, 1.0f);
    glClear (GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    
    for(int j = 0; j < XSTRIPS; j++)
    {
        for(int i = 0; i < YSTRIPS; i++)
        {
            float grey = arc4random_uniform(25);
            float alpha = 1;
            glColor4f(grey, grey, grey, alpha);
            glBegin(GL_QUADS);
            glVertex2f(i+XBORDER, j+YBORDER); glVertex2f(i+1+XBORDER, j+YBORDER);
            glVertex2f(i+1+XBORDER, j+1+YBORDER); glVertex2f(i+XBORDER, j+1+YBORDER);
            glEnd();
        }
    }
    
    //draw a border around the detector
    glColor3f(1, 1, 1);
    glBegin(GL_LINE_LOOP);
    glVertex2f(XBORDER, YBORDER); glVertex2f(XBORDER+XSTRIPS, YBORDER);
    glVertex2f(XBORDER+XSTRIPS, YBORDER+YSTRIPS); glVertex2f(XBORDER, YBORDER+YSTRIPS);
    glEnd();
    
    //draw a border around the detector
    glColor3f(1, 1, 1);
    glBegin(GL_LINES);
    glVertex2f(XBORDER, YBORDER); glVertex2f(XBORDER+XSTRIPS, YBORDER);
    glVertex2f(XBORDER+XSTRIPS, YBORDER+YSTRIPS); glVertex2f(XBORDER, YBORDER+YSTRIPS);
    glEnd();
    
    // draw vertical line at center of detector
    glColor3f(0, 0.5, 0);
    glBegin(GL_LINES);
    glVertex2f(XSTRIPS/2.0 + XBORDER + 0.5, YBORDER);
    glVertex2f(XSTRIPS/2.0 + XBORDER + 0.5, YSTRIPS + YBORDER);	glEnd();
    glEnd();
    
    // draw vertical line at center of detector
    glColor3f(0, 0.5, 0);
    glBegin(GL_LINES);
    glVertex2f(XBORDER, YSTRIPS/2.0 + YBORDER + 0.5);
    glVertex2f(XSTRIPS + XBORDER, YSTRIPS/2.0 + YBORDER + 0.5);
    glEnd();
    
    glPopMatrix();
    glFinish();
    glFlush();
    
    //[self setNeedsDisplay:YES];
    // Drawing code here.
}

- (void)prepareOpenGL
{
    GLint parm = 1;
    
    /* Enable beam-synced updates. */
    
    [[self openGLContext] setValues:&parm forParameter:NSOpenGLCPSwapInterval];
    
    /* Make sure that everything we don't need is disabled. Some of these
     * are enabled by default and can slow down rendering. */
    
    glDisable(GL_ALPHA_TEST);
    glDisable(GL_DEPTH_TEST);
    glDisable(GL_SCISSOR_TEST);
    glDisable(GL_BLEND);
    glDisable(GL_DITHER);
    glDisable(GL_CULL_FACE);
    glColorMask(GL_TRUE, GL_TRUE, GL_TRUE, GL_TRUE);
    glDepthMask(GL_FALSE);
    glStencilMask(0);
    glClearColor(1.0f, 1.0f, 1.0f, 0.0f);
    glHint(GL_TRANSFORM_HINT_APPLE, GL_FASTEST);
    
    NSRect bounds = [self bounds];
    glViewport(0, 0, bounds.size.width, bounds.size.height);
    
    glMatrixMode(GL_PROJECTION);
    glLoadIdentity();
    glOrtho(0,XSTRIPS+2*XBORDER,0,YSTRIPS+2*YBORDER,0, -1);
    
    glMatrixMode(GL_MODELVIEW);
    glLoadIdentity();
}

+ (NSOpenGLPixelFormat *)defaultPixelFormat
{
    static NSOpenGLPixelFormat *pf;
    
    if (pf == nil)
    {
        /*
         Making sure the context's pixel format doesn't have a recovery renderer is important - otherwise CoreImage may not be able to create deeper context's that share textures with this one.
         */
        static const NSOpenGLPixelFormatAttribute attr[] = {
            NSOpenGLPFAAccelerated,
            NSOpenGLPFANoRecovery,
            NSOpenGLPFAColorSize, 32,
            NSOpenGLPFAAllowOfflineRenderers,  /* Allow use of offline renderers */
            0
        };
        
        pf = [[NSOpenGLPixelFormat alloc] initWithAttributes:(void *)&attr];
    }
    
    return pf;
}


@end