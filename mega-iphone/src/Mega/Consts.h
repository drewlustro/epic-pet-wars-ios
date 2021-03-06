/**
 * Consts.h
 * Copyright Miraphonic, Inc 2009. All rights reserved.
 *
 * Holds any system wide constants
 *
 * @author Amit Matani
 * @created 1/13/09
 */


#define DEBUG YES


#define FRAME_HEIGHT_WITH_NAVIGATION_BAR 436
#define FRAME_HEIGHT_WITH_ALL_BARS 387
#define FRAME_HEIGHT_WITH_NAVIGATION_BAR_AND_PROMPT 406
#define FRAME_WIDTH 320
#define FRAME_HEIGHT_WITH_NO_BARS 480

#define TOP_BAR_LOGO_WIDTH 120
#define TOP_BAR_LOGO_HEIGHT 41

#ifdef DEBUG
#define debug_NSLog(format, ...) NSLog(format, ## __VA_ARGS__)
#else
#define debug_NSLog(format, ...)
#endif
