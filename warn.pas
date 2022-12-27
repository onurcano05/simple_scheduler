unit warn;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs,
  settings;

type

  { TWarn_Frm }

  TWarn_Frm = class(TForm)
    procedure FormCreate(Sender: TObject);
  private

  public
    WarnBeforeAction: Boolean;

  end;

var
  Warn_Frm: TWarn_Frm;

implementation

{$R *.lfm}

{ TWarn_Frm }

procedure TWarn_Frm.FormCreate(Sender: TObject);
var
  Doc: TXMLDocument;
  Nodes: TXMLNodeList;
begin
  Stg:=Settings_Frm.WarnBeforeAction;
end;

end.

