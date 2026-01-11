unit uMain.UI.Menu;

interface

uses
  Winapi.Windows, Winapi.Messages, System.IOUtils, System.SysUtils,
  Vcl.Forms, Clipbrd, ShellAPI;

// Global
procedure UI_UpdateMenu(AForm: TObject);

// File
procedure UI_SaveAs(AForm: TObject);

// View
procedure UI_AlwaysOnTop(AForm: TObject; Toggle: Boolean = True);

// Tool
procedure UI_ClearClipboard(AForm: TObject);

// Help
procedure UI_ShowAbout(AForm: TObject);

implementation

uses
  uMain, uMain.UI.Messages;

procedure UI_UpdateMenu(AForm: TObject);
var
  F: TfrmMain;
begin
  if not (AForm is TfrmMain) then Exit;
  F := TfrmMain(AForm);

  if Assigned(F.mmuSaveAs) and Assigned(F.redResult) then
    F.mmuSaveAs.Enabled := F.redResult.Text <> '';

  if Assigned(F.mmuClearClipboard) then
    F.mmuClearClipboard.Enabled := IsClipboardFormatAvailable(CF_UNICODETEXT) or
                                   IsClipboardFormatAvailable(CF_TEXT)        or
                                   IsClipboardFormatAvailable(CF_BITMAP)      or
                                   IsClipboardFormatAvailable(CF_DIB)         or
                                   IsClipboardFormatAvailable(CF_HDROP);
end;

procedure UI_SaveAs(AForm: TObject);
var
  F: TfrmMain;
  FileName: string;
  Enc: TEncoding;
begin
  if not (AForm is TfrmMain) then Exit;
  F := TfrmMain(AForm);

  if F.redResult.Text = '' then Exit;
  if not Assigned(F.sSaveDlg) then Exit;

  F.sSaveDlg.FileName := Format('PG_%s.txt', [FormatDateTime('yyyymmdd_hhnnss', Now)]);

  if not F.sSaveDlg.Execute then Exit;

  FileName := F.sSaveDlg.FileName;
  if ExtractFileExt(FileName) = '' then
    FileName := FileName + '.txt';

  Enc := TUTF8Encoding.Create(False);
  try
    try
      TFile.WriteAllText(FileName, F.redResult.Lines.Text, Enc);
    except
      on E: Exception do
      begin
        UI_MessageBox(F, Format(SFileSaveErrMsg, [FileName, E.Message]), MB_ICONERROR or MB_OK);
        Exit;
      end;
    end;
  finally
    Enc.Free;
  end;

  if UI_ConfirmYesNo(F, Format(SFileSavedMsg, [FileName]) + sLineBreak + sLineBreak + SOpenFileMsg) then
  begin
    if ShellExecute(0, 'open', PChar(FileName), nil, nil, SW_SHOWNORMAL) <= 32 then
      UI_MessageBox(F, SOpenFileFailMsg, MB_ICONWARNING or MB_OK);
  end;
end;

procedure UI_AlwaysOnTop(AForm: TObject; Toggle: Boolean);
var
  F: TfrmMain;
begin
  if not (AForm is TfrmMain) then Exit;
  F := TfrmMain(AForm);

  if Toggle then
    F.FAlwaysOnTop := not F.FAlwaysOnTop;

  if F.FAlwaysOnTop then
    SetWindowPos(F.Handle, HWND_TOPMOST, 0, 0, 0, 0, SWP_NOMOVE or SWP_NOSIZE)
  else
    SetWindowPos(F.Handle, HWND_NOTOPMOST, 0, 0, 0, 0, SWP_NOMOVE or SWP_NOSIZE);

  if Assigned(F.mmuAlwaysOnTop) then
    F.mmuAlwaysOnTop.Checked := F.FAlwaysOnTop;
end;

procedure UI_ClearClipboard(AForm: TObject);
var
  F: TfrmMain;
begin
  if not (AForm is TfrmMain) then Exit;
  F := TfrmMain(AForm);

  try
    Clipboard.Clear;
  except
    on E: Exception do
      UI_MessageBox(F, Format(SClipboardClearErrMsg, [E.Message]), MB_ICONWARNING or MB_OK);
  end;
  UI_UpdateMenu(F);
end;

procedure UI_ShowAbout(AForm: TObject);
var
  F: TfrmMain;
begin
  if not (AForm is TfrmMain) then Exit;
  F := TfrmMain(AForm);

  UI_MessageBox(F, Format(SAboutMsg, [APP_NAME, APP_VERSION, APP_RELEASE, APP_URL]), MB_ICONQUESTION or MB_OK);
end;

end.
