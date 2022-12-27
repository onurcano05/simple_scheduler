unit lng;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Dialogs,
  dom, xmlread, XMLUtils;

type

  {LanguageUnit1}

  TLanguageUnit1=class


  private
    FDefaultLanguage: ShortString;
    FCurrentLanguage: ShortString;

    FActionLblCaption: ShortString;
    FFileLblCaption: ShortString;
    FParametersLblCaption: ShortString;
    FStatusLblCaption: ShortString;
    FMainGbxCaption: ShortString;
    FScheduleRgpCaption: ShortString;
    FActionCmbxRunAProgram: ShortString;
    FActionCmbxLogOff: ShortString;
    FActionCmbxStandBy: ShortString;
    FActionCmbxReboot: ShortString;
    FActionCmbxShutDown: ShortString;
    FActionCmbxForceLogOff: ShortString;
    FActionCmbxForceStandBy: ShortString;
    FActionCmbxForceReboot: ShortString;
    FActionCmbxForceShutDown: ShortString;
    FOneTimeRbtnCaption: ShortString;
    FCountDownRbtnCaption: ShortString;
    FCountDown2LblCaption: ShortString;
    FIdleRbtnCaption: ShortString;
    FIdle2LblCaption: ShortString;
    FSelectBtnCaption: ShortString;
    FRunNowBtnCaption: ShortString;
    FStartBtnCaption: ShortString;
    FSettingsBtnCaption: ShortString;
    FShellExecuteErrorTitle: String;
    FShellExecuteErrorPrefix: ShortString;
    FNullFileMsg: ShortString;
    FNullActionMsg: ShortString;
    FOneTimeStatusStr: ShortString;
    FOneTimeCountDownDialogStr: ShortString;
    FCountDownStatusStr: ShortString;
    FCountDownCountDownDialogStr: ShortString;
    FIdleStatusStr: ShortString;
    FApprovalStatusStr: ShortString;
    FIdleCountDownDialogStr: ShortString;
    FNewUpdatesAvailableMsg: ShortString;
    FStringToBooleanErrorMsg: ShortString;
    FSettingsFrmCaption: ShortString;
    FSettingsTshCaption: ShortString;
    FAboutTshCaption: ShortString;
    FCheckForUpdatesChbxCaption: ShortString;
    FRememberInputsChbxCaption: ShortString;
    FWarnBeforeActionChbxCaption: ShortString;
    FLanguageLblCaption: ShortString;
    FTimeOutLblCaption: ShortString;
    FTimeOutSecsLblCaption: ShortString;
    FCloseBtnCaption: ShortString;
    FAboutLblCaption: ShortString;
    FDonateLblCaption: ShortString;
    FTimeOutDescriptionLblCaption: ShortString;
    FDescriptionLblCaption: ShortString;
    FYesBtnCaption: ShortString;
    FNoBtnCaption: ShortString;
    FNotAssignedErrorStr: ShortString;
    FStringToBooleanErrorStr: ShortString;
    FRestartOfProgramRequiredMsg: ShortString;
    FRestartOfProgramRequiredLblCaption: ShortString;
  public
    property DefaultLanguage: ShortString read FDefaultLanguage write FDefaultLanguage;
    property CurrentLanguage: ShortString read FCurrentLanguage write FCurrentLanguage;

    property ActionLblCaption: ShortString read FActionLblCaption;
    property FileLblCaption: ShortString read FFileLblCaption;
    property ParametersLblCaption: ShortString read FParametersLblCaption;
    property StatusLblCaption: ShortString read FStatusLblCaption;
    property MainGbxCaption: ShortString read FMainGbxCaption;
    property ScheduleRgpCaption: ShortString read FScheduleRgpCaption;
    property ActionCmbxRunAProgram: ShortString read FActionCmbxRunAProgram;
    property ActionCmbxLogOff: ShortString read FActionCmbxLogOff;
    property ActionCmbxStandBy: ShortString read FActionCmbxStandBy;
    property ActionCmbxReboot: ShortString read FActionCmbxReboot;
    property ActionCmbxShutDown: ShortString read FActionCmbxShutDown;
    property ActionCmbxForceLogOff: ShortString read FActionCmbxForceLogOff;
    property ActionCmbxForceStandBy: ShortString read FActionCmbxForceStandBy;
    property ActionCmbxForceReboot: ShortString read FActionCmbxForceReboot;
    property ActionCmbxForceShutDown: ShortString read FActionCmbxForceShutDown;
    property OneTimeRbtnCaption: ShortString read FOneTimeRbtnCaption;
    property CountDownRbtnCaption: ShortString read FCountDownRbtnCaption;
    property CountDown2LblCaption: ShortString read FCountDown2LblCaption;
    property IdleRbtnCaption: ShortString read FIdleRbtnCaption;
    property Idle2LblCaption: ShortString read FIdle2LblCaption;
    property SelectBtnCaption: ShortString read FSelectBtnCaption;
    property RunNowBtnCaption: ShortString read FRunNowBtnCaption;
    property StartBtnCaption: ShortString read FStartBtnCaption;
    property SettingsBtnCaption: ShortString read FSettingsBtnCaption;
    property ShellExecuteErrorTitle: String read FShellExecuteErrorTitle;
    property ShellExecuteErrorPrefix: ShortString read FShellExecuteErrorPrefix;
    property NullFileMsg: ShortString read FNullFileMsg;
    property NullActionMsg: ShortString read FNullActionMsg;
    property OneTimeStatusStr: ShortString read FOneTimeStatusStr;
    property OneTimeCountDownDialogStr: ShortString read FOneTimeCountDownDialogStr;
    property CountDownStatusStr: ShortString read FCountDownStatusStr;
    property CountDownCountDownDialogStr: ShortString read FCountDownCountDownDialogStr;
    property IdleStatusStr: ShortString read FIdleStatusStr;
    property ApprovalStatusStr: ShortString read FApprovalStatusStr;
    property IdleCountDownDialogStr: ShortString read FIdleCountDownDialogStr;
    property NewUpdatesAvailableMsg: ShortString read FNewUpdatesAvailableMsg;
    property StringToBooleanErrorMsg: ShortString read FStringToBooleanErrorMsg;
    property SettingsFrmCaption: ShortString read FSettingsFrmCaption;
    property SettingsTshCaption: ShortString read FSettingsTshCaption;
    property AboutTshCaption: ShortString read FAboutTshCaption;
    property CheckForUpdatesChbxCaption: ShortString read FCheckForUpdatesChbxCaption;
    property RememberInputsChbxCaption: ShortString read FRememberInputsChbxCaption;
    property WarnBeforeActionChbxCaption: ShortString read FWarnBeforeActionChbxCaption;
    property LanguageLblCaption: ShortString read FLanguageLblCaption;
    property TimeOutLblCaption: ShortString read FTimeOutLblCaption;
    property TimeOutSecsLblCaption: ShortString read FTimeOutSecsLblCaption;
    property CloseBtnCaption: ShortString read FCloseBtnCaption;
    property AboutLblCaption: ShortString read FAboutLblCaption write FAboutLblCaption;
    property DonateLblCaption: ShortString read FDonateLblCaption;
    property TimeOutDescriptionLblCaption: ShortString read FTimeOutDescriptionLblCaption;
    property DescriptionLblCaption: ShortString read FDescriptionLblCaption;
    property YesBtnCaption: ShortString read FYesBtnCaption;
    property NoBtnCaption: ShortString read FNoBtnCaption;
    property NotAssignedErrorStr: ShortString read FNotAssignedErrorStr;
    property StringToBooleanErrorStr: ShortString read FStringToBooleanErrorStr;
    property RestartOfProgramRequiredMsg: ShortString read FRestartOfProgramRequiredMsg;
    property RestartOfProgramRequiredLblCaption: ShortString read FRestartOfProgramRequiredLblCaption;
    procedure SetText;

  end;

implementation

procedure TLanguageUnit1.SetText;
var
  Doc: TXMLDocument;
  XMLNodeList: TDOMNodeList;
  FilePath: String;
  LangNum: Integer;
  I: Integer;
  Id: ShortString;
  Str: ^String;

  // ListOfDebug: TStringList;
begin
  New(Str);
  Str^:='';

  {ListOfDebug:=TStringList.Create;
  ListOfDebug.Sorted:=False;
  ListOfDebug.LoadFromFile('debug.txt', TEncoding.UTF8);}

  FilePath:='';
  FilePath:=GetCurrentDir + '\languages.xliff';
  if (FileExists(FilePath)) then
  begin
    ReadXMLFile(Doc, FilePath);
  end
  else
  begin
    ShowMessage('language file not found');
    Halt (0);
  end;

  if (DefaultLanguage='english') then
  begin
    LangNum:=0;
    end
  else if (DefaultLanguage='turkish') then
  begin
    LangNum:=1;
  end;

  XMLNodeList:=Doc.FirstChild.ChildNodes[0].ChildNodes[0].ChildNodes;
  for I := 0 to XMLNodeList.Count - 1 do
  begin
    Id:=XMLNodeList[I].Attributes[0].NodeValue;
    Str^:=XMLNodeList[I].ChildNodes[LangNum].TextContent;

    if (Id='actionLblCaption') then begin FActionLblCaption:=Str^ end
    else if (Id='fileLblCaption') then begin FFileLblCaption:=Str^ end
    else if (Id='parametersLblCaption') then begin FParametersLblCaption:=Str^ end
    else if (Id='statusLblCaption') then begin FStatusLblCaption:=Str^ end
    else if (Id='mainGbxCaption') then begin FMainGbxCaption:=Str^ end
    else if (Id='scheduleRgpCaption') then begin FScheduleRgpCaption:=Str^ end
    else if (Id='actionCmbxRunAProgram') then begin FActionCmbxRunAProgram:=Str^ end
    else if (Id='actionCmbxLogOff') then begin FActionCmbxLogOff:=Str^ end
    else if (Id='actionCmbxStandBy') then begin FActionCmbxStandBy:=Str^ end
    else if (Id='actionCmbxReboot') then begin FActionCmbxReboot:=Str^ end
    else if (Id='actionCmbxShutDown') then begin FActionCmbxShutDown:=Str^ end
    else if (Id='actionCmbxForceLogOff') then begin FActionCmbxForceLogOff:=Str^ end
    else if (Id='actionCmbxForceStandBy') then begin FActionCmbxForceStandBy:=Str^ end
    else if (Id='actionCmbxForceReboot') then begin FActionCmbxForceReboot:=Str^ end
    else if (Id='actionCmbxForceShutDown') then begin FActionCmbxForceShutDown:=Str^ end
    else if (Id='oneTimeRbtnCaption') then begin FOneTimeRbtnCaption:=Str^ end
    else if (Id='countDownRbtnCaption') then begin FCountDownRbtnCaption:=Str^ end
    else if (Id='countDown2LblCaption') then begin FCountDown2LblCaption:=Str^ end
    else if (Id='IdleRbtnCaption') then begin FIdleRbtnCaption:=Str^ end
    else if (Id='idle2LblCaption') then begin FIdle2LblCaption:=Str^ end
    else if (Id='selectBtnCaption') then begin FSelectBtnCaption:=Str^ end
    else if (Id='runNowBtnCaption') then begin FRunNowBtnCaption:=Str^ end
    else if (Id='startBtnCaption') then begin FStartBtnCaption:=Str^ end
    else if (Id='settingsBtnCaption') then begin FSettingsBtnCaption:=Str^ end
    else if (Id='shellExecuteErrorTitle') then begin FShellExecuteErrorTitle:=Str^ end
    else if (Id='shellExecuteErrorPrefix') then begin FShellExecuteErrorPrefix:=Str^ end
    else if (Id='nullFileMsg') then begin FNullFileMsg:=Str^ end
    else if (Id='nullActionMsg') then begin FNullActionMsg:=Str^ end
    else if (Id='oneTimeStatusStr') then begin FOneTimeStatusStr:=Str^ end
    else if (Id='oneTimeCountDownDialogStr') then begin FOneTimeCountDownDialogStr:=Str^ end
    else if (Id='countDownStatusStr') then begin FCountDownStatusStr:=Str^ end
    else if (Id='countDownCountDownDialogStr') then begin FCountDownCountDownDialogStr:=Str^ end
    else if (Id='idleStatusStr') then begin FIdleStatusStr:=Str^ end
    else if (Id='approvalStatusStr') then begin FApprovalStatusStr:=Str^ end
    else if (Id='idleCountDownDialogStr') then begin FIdleCountDownDialogStr:=Str^ end
    else if (Id='newUpdatesAvailableMsg') then begin FNewUpdatesAvailableMsg:=Str^ end
    else if (Id='stringToBooleanErrorMsg') then begin FStringToBooleanErrorMsg:=Str^ end
    else if (Id='settingsFrmCaption') then begin FSettingsFrmCaption:=Str^ end
    else if (Id='settingsTshCaption') then begin FSettingsTshCaption:=Str^ end
    else if (Id='aboutTshCaption') then begin FAboutTshCaption:=Str^ end
    else if (Id='checkForUpdatesChbxCaption') then begin FCheckForUpdatesChbxCaption:=Str^ end
    else if (Id='rememberInputsChbxCaption') then begin FRememberInputsChbxCaption:=Str^ end
    else if (Id='warnBeforeActionChbxCaption') then begin FWarnBeforeActionChbxCaption:=Str^ end
    else if (Id='languageLblCaption') then begin FLanguageLblCaption:=Str^ end
    else if (Id='timeOutLblCaption') then begin FTimeOutLblCaption:=Str^ end
    else if (Id='timeOutSecsLblCaption') then begin FTimeOutSecsLblCaption:=Str^ end
    else if (Id='closeBtnCaption') then begin FCloseBtnCaption:=Str^ end
    else if (Id='aboutLblCaption') then begin FAboutLblCaption:=Str^ end
    else if (Id='donateLblCaption') then begin FDonateLblCaption:=Str^ end
    else if (Id='timeOutDescriptionLblCaption') then begin FTimeOutDescriptionLblCaption:=Str^ end
    else if (Id='yesBtnCaption') then begin FYesBtnCaption:=Str^ end
    else if (Id='noBtnCaption') then begin FNoBtnCaption:=Str^ end
    else if (Id='notAssignedErrorStr') then begin FNotAssignedErrorStr:=Str^ end
    else if (Id='stringToBooleanErrorStr') then begin FStringToBooleanErrorStr:=Str^ end
    else if (Id='restartOfProgramRequiredMsg') then begin FRestartOfProgramRequiredMsg:=Str^ end
    else if (Id='restartOfProgramRequiredLblCaption') then begin FRestartOfProgramRequiredLblCaption:=Str^ end;
  end;

  { ListOfDebug.SaveToFile('debug.txt', TEncoding.UTF8);
  ListOfDebug.Free; }
end;

end.

