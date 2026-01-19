program PasswordGenerator;

uses
  Vcl.Forms,
  Winapi.Windows,
  uMain in 'uMain.pas' {frmMain},
  uMain.UI.Settings in 'uMain.UI.Settings.pas',
  uMain.UI.Messages in 'uMain.UI.Messages.pas',
  uMain.UI in 'uMain.UI.pas',
  uMain.UI.Menu in 'uMain.UI.Menu.pas',
  uPassword in 'uPassword.pas',
  uMain.UI.Strings in 'uMain.UI.Strings.pas';

var
  uMutex: THandle;

{$O+} {$SetPEFlags IMAGE_FILE_RELOCS_STRIPPED}
{$R *.res}

begin
  uMutex := CreateMutex(nil, True, 'PG!');
  if (uMutex <> 0 ) and (GetLastError = 0) then begin

  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;

  if uMutex <> 0 then
    CloseHandle(uMutex);
  end;
end.
