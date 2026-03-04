program PasswordGenerator;

uses
  Winapi.Windows,
  Vcl.Forms,
  uMain in 'uMain.pas' {frmMain},
  uAppController in 'uAppController.pas',
  uAppMenu in 'uAppMenu.pas',
  uAppSettings in 'uAppSettings.pas',
  uPassword in 'uPassword.pas',
  uAppStrings in 'uAppStrings.pas',
  uForms in '..\Common\uForms.pas',
  uMenu in '..\Common\uMenu.pas',
  uMessageBox in '..\Common\uMessageBox.pas',
  uSettings in '..\Common\uSettings.pas';

var
  uMutex: THandle;

{$R *.res}

begin
  uMutex := CreateMutex(nil, True, 'PG!');
  if (uMutex <> 0) and (GetLastError = 0) then
  begin
    Application.Initialize;
    Application.MainFormOnTaskbar := True;
    Application.CreateForm(TfrmMain, frmMain);
    Application.Run;

    if uMutex <> 0 then
      CloseHandle(uMutex);
  end;
end.
