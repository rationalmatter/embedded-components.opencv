//
//  Created by Alex Staravoitau on 24/11/2024.
//

// Include necessary OpenCV headers
#include "opencv2/highgui.hpp"
#include "opencv2/imgproc.hpp"
#import "JunoOpenCVBackend.h"
#import "MatConverters.h"

namespace cv {
namespace highgui_backend {

// Implement cvNamedWindow (stub or minimal implementation)
int cvNamedWindow(const char* name, int flags) {
    // For now, minimal implementation
    return 1; // Success
}

void cvDestroyWindow(const char* name) {
    // For now, stub implementation
}

void cvDestroyAllWindows() {
    // For now, stub implementation
}

void cvShowImage(const char* name, const CvArr* arr) {
    cv::Mat mat = cv::cvarrToMat(arr);
    UIImage* uiImage = [MatConverters convertMatToUIImage:mat];
    [JunoOpenCVBackend showImage:uiImage withName:[NSString stringWithUTF8String:name]];
}

int cvWaitKey(int delay) {
    // For now, return immediately
    return -1;
}

void cvResizeWindow(const char* name, int width, int height) {
    // For now, stub implementation
}

void cvMoveWindow(const char* name, int x, int y) {
    // For now, stub implementation
}

void cvSetMouseCallback(const char* windowName, CvMouseCallback onMouse, void* param) {
    // For now, stub implementation
}

int cvCreateTrackbar(const char* trackbarName, const char* windowName,
                     int* value, int count, CvTrackbarCallback onChange) {
    // For now, stub implementation
    return 0; // Success
}

int cvGetTrackbarPos(const char* trackbarName, const char* windowName) {
    // For now, stub implementation
    return 0;
}

void cvSetTrackbarPos(const char* trackbarName, const char* windowName, int pos) {
    // For now, stub implementation
}

int cvCreateButton(const char* buttonName, CvButtonCallback onClick, void* userdata,
                   int buttonType, int initialButtonState) {
    // For now, stub implementation
    return 0; // Success
}

double cvGetWindowProperty(const char* windowName, int propId) {
    // For now, stub implementation
    return 0.0;
}

void cvSetWindowProperty(const char* windowName, int propId, double propValue) {
    // For now, stub implementation
}

int cvWaitKeyEx(int delay) {
    // For now, stub implementation
    return -1;
}

cv::Rect cvGetWindowImageRect(const char* windowName) {
    // For now, stub implementation
    return cv::Rect();
}

int cvStartWindowThread() {
    // For now, stub implementation
    return 0;
}

void cvInitSystem(int argc, char** argv) {
    // For now, stub implementation
}

// Implement cvImshow (overload for cv::Mat)
void cvImshow(const cv::String& winname, cv::InputArray mat) {
    cvShowImage(winname.c_str(), mat.getMat().operator const CvArr*());
}

} // namespace highgui_backend
} // namespace cv
