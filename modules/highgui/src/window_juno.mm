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
#import <opencv2/imgcodecs/ios.h>

namespace cv {
namespace highgui_backend {

class JunoTrackbar;

class JunoWindow
        : public UIWindow
        , public std::enable_shared_from_this<JunoWindow>
{
protected:
    const std::string name_;
    std::map<std::string, std::shared_ptr<JunoTrackbar> > trackbars_;
public:
    JunoWindow(const std::string& name)
        : name_(name)
    {
        // nothing
    }

    ~JunoWindow() CV_OVERRIDE
    {
    }

    const std::string& getID() const CV_OVERRIDE { return name_; }

    bool isActive() const CV_OVERRIDE { return true; }

    void destroy() CV_OVERRIDE
    {
    }

    void imshow(InputArray image) CV_OVERRIDE
    {
        const cv::Mat& mat = image.getMat();
        UIImage* uiImage = MatToUIImage(mat);
        [JunoOpenCVBackend showImage:uiImage withName:[NSString stringWithUTF8String:name_.c_str()]];
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
    }

    void move(int x, int y) CV_OVERRIDE
    {
    }

    Rect getImageRect() const CV_OVERRIDE
    {
        // For now, stub implementation
        return cv::Rect();
    }

    void setTitle(const std::string& title) CV_OVERRIDE
    {
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
    std::string name_;
    std::weak_ptr<JunoWindow> parent_;
    std::map<std::string, std::shared_ptr<JunoTrackbar> > trackbars_;
public:
    JunoTrackbar(const std::string& name,  const std::shared_ptr<JunoWindow>& parent)
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

} // namespace highgui_backend
} // namespace cv
