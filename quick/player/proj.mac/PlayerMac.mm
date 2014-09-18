

#include "PlayerMac.h"

// for network
#include "cocos2dx_extra.h"
#include "network/CCHTTPRequest.h"
#include "native/CCNative.h"

PLAYER_NS_BEGIN

using namespace cocos2d;
USING_NS_CC_EXTRA;

PlayerMac* PlayerMac::create()
{
    return new PlayerMac();
}


PlayerMac::PlayerMac()
: PlayerProtocol()
, _fileDialogService(nullptr)
, _messageBoxService(nullptr)
, _menuService(nullptr)
, _editBoxService(nullptr)
, _appController(nullptr)
, _taskService(nullptr)
{
}


PlayerMac::~PlayerMac()
{
    CC_SAFE_DELETE(_fileDialogService);
    CC_SAFE_DELETE(_fileDialogService);
    CC_SAFE_DELETE(_messageBoxService);
    CC_SAFE_DELETE(_menuService);
    CC_SAFE_DELETE(_editBoxService);
    CC_SAFE_DELETE(_taskService);
}

PlayerFileDialogServiceProtocol *PlayerMac::getFileDialogService()
{
    if (!_fileDialogService)
    {
        _fileDialogService = new PlayerFileDialogServiceMac();
    }
    return _fileDialogService;
}

PlayerMessageBoxServiceProtocol *PlayerMac::getMessageBoxService()
{
    if (!_messageBoxService)
    {
        _messageBoxService = new PlayerMessageBoxServiceMac();
    }
    return _messageBoxService;
}

PlayerMenuServiceProtocol *PlayerMac::getMenuService()
{
    if (!_menuService)
    {
        _menuService = new PlayerMenuServiceMac();
    }
    return _menuService;
}

PlayerEditBoxServiceProtocol *PlayerMac::getEditBoxService()
{
    if (!_editBoxService)
    {
        _editBoxService = new PlayerEditBoxServiceMac();
    }
    return _editBoxService;
}

PlayerTaskServiceProtocol *PlayerMac::getTaskService()
{
    
    if (!_taskService)
    {
        _taskService = new PlayerTaskServiceMac();
    }
    return _taskService;
}

void PlayerMac::quit()
{
    cocos2d::Director::getInstance()->end();
}

void PlayerMac::relaunch()
{
    if (_appController && [_appController respondsToSelector:NSSelectorFromString(@"relaunch")])
    {
        [_appController performSelector:NSSelectorFromString(@"relaunch")];
    }
}

void PlayerMac::openNewPlayer()
{
}

void PlayerMac::openNewPlayerWithProjectConfig(const ProjectConfig& config)
{
    if (_appController && [_appController respondsToSelector:NSSelectorFromString(@"launch:")])
    {
        NSString *commandLine = [NSString stringWithCString:config.makeCommandLine().c_str()
                                                   encoding:NSUTF8StringEncoding];
        NSArray *arguments = [NSMutableArray arrayWithArray:[commandLine componentsSeparatedByString:@" "]];
        
        [_appController performSelector:NSSelectorFromString(@"launch:") withObject:arguments];
    }
}

void PlayerMac::openProjectWithProjectConfig(const ProjectConfig& config)
{
    this->openNewPlayerWithProjectConfig(config);
    this->quit();
}

void PlayerMac::trackEvent(const char* eventName)
{
    HTTPRequest *request = HTTPRequest::createWithUrl(NULL,
                                                          "http://www.google-analytics.com/collect",
                                                          kCCHTTPRequestMethodPOST);
    request->addPOSTValue("v", "1");
    request->addPOSTValue("tid", "UA-52790340-1");
    request->addPOSTValue("cid", Native::getOpenUDID().c_str());
    request->addPOSTValue("t", "event");
    
    request->addPOSTValue("an", "player");
    request->addPOSTValue("av", cocos2dVersion());
    
	request->addPOSTValue("ec", "mac");
    request->addPOSTValue("ea", eventName);
    
    request->start();
}

void PlayerMac::setController(id controller)
{
    _appController = controller;
}

PLAYER_NS_END
