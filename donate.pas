unit donate;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls;

type

  { TFormDonate }

  TFormDonate = class(TForm)
    CardNumberCaption_Lbl: TLabel;
    CardNumber_Lbl: TLabel;
    IbanCaption_Lbl: TLabel;
    Iban_Lbl: TLabel;
  private

  public

  end;

var
  FormDonate: TFormDonate;

implementation

{$R *.lfm}

end.

