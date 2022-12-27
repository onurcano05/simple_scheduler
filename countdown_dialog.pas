unit countdown_dialog;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  ExtCtrls, JwaWindows,
  Lng;

type

  { TCountDownDialog_Frm }

  TCountDownDialog_Frm = class(TForm)
    Action_Lbl: TLabel;
    Description_Lbl: TLabel;
    Yes_Btn: TButton;
    No_Btn: TButton;
    Warning_Tmr: TTimer;
    procedure FormShow(Sender: TObject);
    procedure Warning_TmrTimer(Sender: TObject);

  private
    FDescription: String;
    FWarnRequest: Boolean;
    FTimeOut: ShortString;
    LanguageUnit: TLanguageUnit1;
    FActionText: String;
    FYesBtnCaption: ShortString;
    FNoBtnCaption: ShortString;

  public
    property Description: String read FDescription write FDescription;
    property WarnRequest: Boolean read FWarnRequest write FWarnRequest;
    property TimeOut: ShortString read FTimeOut write FTimeOut;
    property ActionText: String read FActionText write FActionText;
    property YesBtnCaption: ShortString read FYesBtnCaption write FYesBtnCaption;
    property NoBtnCaption: ShortString read FNoBtnCaption write FNoBtnCaption;

  end;

var
  CountDownDialog_Frm: TCountDownDialog_Frm;
  SecondsElapsed: Integer;

implementation

{$R *.lfm}

{ TCountDownDialog_Frm }


procedure TCountDownDialog_Frm.FormShow(Sender: TObject);
begin
  SecondsElapsed:=StrToInt(FTimeOut);
  Warning_Tmr.Enabled:=True;
  Action_Lbl.Caption:=FActionText;

  Description_Lbl.Caption:=FDescription;
  Yes_Btn.Caption:=FYesBtnCaption;
  No_Btn.Caption:=FNoBtnCaption;
end;

procedure TCountDownDialog_Frm.Warning_TmrTimer(Sender: TObject);
begin
  Yes_Btn.Caption:=YesBtnCaption + ' (' + SecondsElapsed.ToString + ')';
  SecondsElapsed:=SecondsElapsed-1;
  if (SecondsElapsed<=0) then
  begin
    Warning_Tmr.Enabled:=False;
    ModalResult:=mrYes;
  end;
end;

end.

