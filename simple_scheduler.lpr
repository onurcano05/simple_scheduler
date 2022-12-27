program simple_scheduler;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms, Unit1, settings, countdown_dialog, lng, GenerateVersionFile, vinfo,
  Config, Token;

{$R *.res}

begin
  Application.Title:='Simple Scheduler';
  RequireDerivedFormResource:=True;
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TSettings_Frm, Settings_Frm);
  Application.CreateForm(TCountDownDialog_Frm, CountDownDialog_Frm);
  Application.Run;
end.

