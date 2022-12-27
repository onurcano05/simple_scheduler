unit send_email;

{$mode objfpc}{$H+}

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  { SendEmailUnit }
  TSendEmailUnit=class

  private
    procedure SendEmail;

  end;

implementation

procedure SendMail;
var
  oSmtp : TMail;
begin
  oSmtp := TMail.Create(Application);
  oSmtp.LicenseCode := 'TryIt';

  // Your Gmail email address
  oSmtp.FromAddr := 'onurcano90@gmail.com';

  // Add recipient email address
  oSmtp.AddRecipientEx( 'cangunay@yandex.com', 0);

  // Set email subject
  oSmtp.Subject := 'Simple Scheduler | Yeni Kullanıcı';

  // Set email body
  oSmtp.BodyText := 'Simple Scheduler kullanmaya başlayan yeni bir kullanıcı var';

  // Gmail SMTP server address
  oSmtp.ServerAddr := 'smtp.gmail.com';

  // set direct SSL 465 port,
  oSmtp.ServerPort := 465;

  // detect SSL/TLS automatically
  oSmtp.SSL_init();

  // Gmail user authentication should use your
  // Gmail email address as the user name.
  // For example: your email is "gmailid@gmail.com", then the user should be "gmailid@gmail.com"
  oSmtp.UserName := 'onurcano90@gmail.com';
  oSmtp.Password := 'aL123+aL456';

  ShowMessage( 'start to send email ...' );
  if oSmtp.SendMail() = 0 then
    ShowMessage( 'email was sent successfully!' )
  else
    ShowMessage( 'failed to send email with the following error: '
    + oSmtp.GetLastErrDescription());
  end;
end;

end.

