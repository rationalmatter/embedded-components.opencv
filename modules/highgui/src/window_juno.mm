//
//  Created by Alex Staravoitau on 24/11/2024.
//

// Include necessary OpenCV headers
#include "precomp.hpp"
#include "backend.hpp"
#include "opencv2/highgui.hpp"
#include "opencv2/imgproc.hpp"
#import "JunoOpenCVBackend.h"
#import "MatConverters.h"

namespace cv {
namespace highgui_backend {

class JunoTrackbar;

class JunoWindow
        : public UIWindow
        , public std::enable_shared_from_this<JunoWindow>
{
protected:
    const std::string name_;
    //std::weak_ptr<CvWindow> window_;
    std::map<std::string, std::shared_ptr<JunoTrackbar> > trackbars_;
public:
    JunoWindow(const std::string& name)
        : name_(name)
    {
        printf("hello ctor \n");
        // nothing
    }

    ~JunoWindow() CV_OVERRIDE
    {
        printf("hello dtor \n");
    }

    const std::string& getID() const CV_OVERRIDE { return name_; }

    bool isActive() const CV_OVERRIDE { return true; }

    void destroy() CV_OVERRIDE
    {
        printf("hello destroy \n");
    }

    void imshow(InputArray image) CV_OVERRIDE
    {
        printf("hello imshow \n");
    }

    double getProperty(int prop) const CV_OVERRIDE
    {
        return std::numeric_limits<double>::quiet_NaN();
    }

    bool setProperty(int prop, double value) CV_OVERRIDE
    {
        
        return false;
    }

    void resize(int width, int height) CV_OVERRIDE
    {
        printf("hello resize \n");
    }

    void move(int x, int y) CV_OVERRIDE
    {
        printf("hello move \n");
    }

    Rect getImageRect() const CV_OVERRIDE
    {
        // For now, stub implementation
        return cv::Rect();
    }

    void setTitle(const std::string& title) CV_OVERRIDE
    {
        printf("hello setTitle %s \n", title.c_str());
    }

    void setMouseCallback(MouseCallback onMouse, void* userdata /*= 0*/) CV_OVERRIDE
    {
    }

    std::shared_ptr<UITrackbar> createTrackbar(
        const std::string& name,
        int count,
        TrackbarCallback onChange /*= 0*/,
        void* userdata /*= 0*/
    ) CV_OVERRIDE
    {
        auto ui_trackbar = std::make_shared<JunoTrackbar>(name, shared_from_this());
        
        return std::static_pointer_cast<UITrackbar>(ui_trackbar);
    }

    std::shared_ptr<UITrackbar> findTrackbar(const std::string& name) CV_OVERRIDE
    {
        cv::AutoLock lock(getWindowMutex());
        auto i = trackbars_.find(name);
        if (i != trackbars_.end())
        {
            return std::static_pointer_cast<UITrackbar>(i->second);
        }
        return std::shared_ptr<UITrackbar>();
    }
};  // JunoWindow

class JunoTrackbar : public UITrackbar
{
protected:
    /*const*/ std::string name_;
    //std::weak_ptr<CvTrackbar> trackbar_;
    std::weak_ptr<JunoWindow> parent_;
    std::map<std::string, std::shared_ptr<JunoTrackbar> > trackbars_;
public:
    JunoTrackbar(const std::string& name,  const std::shared_ptr<JunoWindow>& parent)
        //: trackbar_(trackbar)
        : parent_(parent)
    {
        name_ = std::string("<") + name + ">@" + parent->getID();
    }

    ~JunoTrackbar() CV_OVERRIDE
    {
    }

    const std::string& getID() const CV_OVERRIDE { return name_; }

    bool isActive() const CV_OVERRIDE { return false; }

    void destroy() CV_OVERRIDE
    {
        // nothing (destroyed with parent window, dedicated trackbar removal is not supported)
    }

    int getPos() const CV_OVERRIDE
    {
        return 0;
    }
    void setPos(int pos) CV_OVERRIDE
    {
        
    }

    cv::Range getRange() const CV_OVERRIDE
    {
        return cv::Range(0, 0);
    }

    void setRange(const cv::Range& range) CV_OVERRIDE
    {
    }
};  // JunoTrackbar


class JunoBackendUI : public UIBackend
{
public:
    JunoBackendUI()
    {
    }
    ~JunoBackendUI() CV_OVERRIDE
    {
        destroyAllWindows();
    }

    void destroyAllWindows() CV_OVERRIDE
    {
        cvDestroyAllWindows();
    }

    // namedWindow
    virtual std::shared_ptr<UIWindow> createWindow(
        const std::string& winname,
        int flags
    ) CV_OVERRIDE
    {
        auto ui_window = std::make_shared<JunoWindow>(winname);
        return ui_window;
    }

    int waitKeyEx(int delay) CV_OVERRIDE
    {
        return cvWaitKey(delay);
    }
    int pollKey() CV_OVERRIDE
    {
        return cvWaitKey(1);  // TODO
    }

    const std::string getName() const CV_OVERRIDE
    {
        return "JUNO";
    }
};  // JunoBackendUI

static
std::shared_ptr<JunoBackendUI>& getInstance()
{
    static std::shared_ptr<JunoBackendUI> g_instance = std::make_shared<JunoBackendUI>();
    return g_instance;
}

std::shared_ptr<UIBackend> createUIBackendJuno()
{
    return getInstance();
}

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
    printf("hello cvShowImage\n");
    /*cv::Mat mat = cv::cvarrToMat(arr);
    UIImage* uiImage = [MatConverters convertMatToUIImage:mat];
    [JunoOpenCVBackend showImage:uiImage withName:[NSString stringWithUTF8String:name]];*/
}

void cvShowImage2(const char* name, const cv::Mat& mat) {
    printf("hello cvShowImage2\n");
//    cv::Mat mat = cv::cvarrToMat(arr);
    //UIImage* uiImage = [MatConverters convertMatToUIImage:mat];
    //[JunoOpenCVBackend showImage:uiImage withName:[NSString stringWithUTF8String:name]];
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

void cvSetMouseCallback(const char* windowName, cv::MouseCallback onMouse, void* param) {
    // For now, stub implementation
}

int cvCreateTrackbar(const char* trackbarName, const char* windowName,
                     int* value, int count, cv::TrackbarCallback onChange) {
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

int cvCreateButton(const char* buttonName, cv::ButtonCallback onClick, void* userdata,
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
    // cvShowImage(winname.c_str(), mat.getMat().operator const cvArr*());
    cvShowImage2(winname.c_str(), mat.getMat());
}

} // namespace highgui_backend
} // namespace cv
