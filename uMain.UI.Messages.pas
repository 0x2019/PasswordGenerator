unit uMain.UI.Messages;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, Vcl.Forms;

resourcestring
  APP_NAME                            = 'Password Generator';
  APP_VERSION                         = 'v1.0.0.0';
  APP_RELEASE                         = 'January 11, 2026';
  APP_URL                             = 'https://github.com/0x2019/PasswordGenerator';

  SFileSavedMsg                       = 'File successfully saved!' + sLineBreak + 'Path: %s';
  SFileSaveErrMsg                     = 'Failed to save the file.' + sLineBreak + 'Path: %s' + sLineBreak + '%s';

  SOpenFileMsg                        = 'Would you like to open the file now?';
  SOpenFileFailMsg                    = 'Failed to open the file.';

  SPwdLenTooSmallMsg                  = 'Length must be greater than 0.';
  SPwdLenTooSmallFmtMsg               = 'Length (%d) is too small for selected groups (%d).';
  SPwdNoGroupSelectedMsg              = 'No character group selected.';

  SClipboardClearErrMsg               = 'Unable to clear the clipboard.' + sLineBreak + '%s';
  SClipboardCopyErrMsg                = 'Unable to copy to the clipboard.' + sLineBreak + '%s';

  SAboutMsg                           = '%s %s' + sLineBreak +
                                        'c0ded by 龍, written in Delphi.' + sLineBreak + sLineBreak +
                                        'Release Date: %s' + sLineBreak +
                                        'URL: %s';

procedure UI_ChangeMessageBoxPosition(AForm: TObject);

function UI_MessageBox(AForm: TObject; const Text: string; Flags: UINT; const Caption: string = ''): Integer;
function UI_ConfirmYesNo(AForm: TObject; const Text: string; const Caption: string = ''): Boolean;
function UI_ConfirmYesNoCancel(AForm: TObject; const Text: string; const Caption: string = ''): Integer;
function UI_ConfirmYesNoWarn(AForm: TObject; const Text: string; const Caption: string = ''): Boolean;

implementation

uses
  uMain;

var
  GCaption: string;
  xMsgCaption: PWideChar;

procedure UI_ChangeMessageBoxPosition(AForm: TObject);
var
  F: TfrmMain;
  mbHWND: LongWord;
  mbRect: TRect;
  x, y, w, h: Integer;
begin
  if not (AForm is TfrmMain) then Exit;
  F := TfrmMain(AForm);

  mbHWND := FindWindow(MAKEINTRESOURCE(WC_DIALOG), xMsgCaption);
  if (mbHWND <> 0) then begin
    GetWindowRect(mbHWND, mbRect);
    with mbRect do begin
      w := Right - Left;
      h := Bottom - Top;
    end;
    x := F.Left + ((F.Width - w) div 2);
    if x < 0 then
      x := 0
    else if x + w > Screen.Width then x := Screen.Width - w;
    y := F.Top + ((F.Height - h) div 2);
    if y < 0 then y := 0
    else if y + h > Screen.Height then y := Screen.Height - h;
    SetWindowPos(mbHWND, 0, x, y, 0, 0, SWP_NOACTIVATE or SWP_NOSIZE or SWP_NOZORDER);
  end;
end;

function UI_MessageBox(AForm: TObject; const Text: string; Flags: UINT; const Caption: string): Integer;
var
  F: TfrmMain;
begin
  Result := 0;
  if not (AForm is TfrmMain) then Exit;
  F := TfrmMain(AForm);

  PostMessage(F.Handle, mbMessage, 0, 0);

  GCaption := Caption;
  xMsgCaption := PWideChar(GCaption);

  Result := Application.MessageBox(PChar(Text), xMsgCaption, Flags);
end;

function UI_ConfirmYesNo(AForm: TObject; const Text: string; const Caption: string): Boolean;
begin
  Result := UI_MessageBox(AForm, Text, MB_ICONQUESTION or MB_YESNO or MB_DEFBUTTON2, Caption) = IDYES;
end;

function UI_ConfirmYesNoCancel(AForm: TObject; const Text: string; const Caption: string): Integer;
begin
  Result := UI_MessageBox(AForm, Text, MB_ICONQUESTION or MB_YESNOCANCEL or MB_DEFBUTTON1, Caption);
end;

function UI_ConfirmYesNoWarn(AForm: TObject; const Text: string; const Caption: string): Boolean;
begin
  Result := UI_MessageBox(AForm, Text, MB_ICONWARNING or MB_YESNO or MB_DEFBUTTON2, Caption) = IDYES;
end;

end.
