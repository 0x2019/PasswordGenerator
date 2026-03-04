unit uAppMenu;

interface

uses
  Winapi.Windows, System.SysUtils, System.Classes, System.IOUtils, Vcl.Forms,
  Vcl.Menus, ShellAPI, Clipbrd, uMain;

procedure AppMenu_Update(AForm: TfrmMain);
procedure AppMenu_SaveAs(AForm: TfrmMain);
procedure AppMenu_ClearClipboard(AForm: TfrmMain);

implementation

uses
  uMenu, uMessageBox,
  uAppStrings;

procedure AppMenu_Update(AForm: TfrmMain);
begin
  if AForm = nil then Exit;

  if Assigned(AForm.miSaveAs) and Assigned(AForm.mmoResult) then
    AForm.miSaveAs.Enabled := AForm.mmoResult.Text <> '';

  UI_Menu_UpdateClipboard(AForm.miClearClipboard);
end;

procedure AppMenu_ClearClipboard(AForm: TfrmMain);
begin
  if AForm = nil then Exit;
  try
    Clipboard.Clear;
  except
    on E: Exception do
      UI_MessageBox(AForm, Format(SClipboardClearErrMsg, [E.Message]), MB_ICONWARNING or MB_OK);
  end;
  AppMenu_Update(AForm);
end;

procedure AppMenu_SaveAs(AForm: TfrmMain);
var
  FileName: string;
  Enc: TEncoding;
begin
  if AForm = nil then Exit;
  if AForm.mmoResult.Text = '' then Exit;
  if not Assigned(AForm.sSaveDlg) then Exit;

  AForm.sSaveDlg.FileName := Format('PG_%s.txt', [FormatDateTime('yyyymmdd_hhnnss', Now)]);

  if not AForm.sSaveDlg.Execute then Exit;

  FileName := AForm.sSaveDlg.FileName;
  if ExtractFileExt(FileName) = '' then
    FileName := FileName + '.txt';

  Enc := TUTF8Encoding.Create(False);
  try
    try
      TFile.WriteAllText(FileName, AForm.mmoResult.Lines.Text, Enc);
    except
      on E: Exception do
      begin
        UI_MessageBox(AForm, Format(SFileSaveFailMsg, [FileName, E.Message]), MB_ICONERROR or MB_OK);
        Exit;
      end;
    end;
  finally
    Enc.Free;
  end;

  if UI_ConfirmYesNo(AForm, Format(SFileSavedMsg, [FileName]) + sLineBreak + sLineBreak + SOpenFileMsg) then
  begin
    if ShellExecute(0, 'open', PChar(FileName), nil, nil, SW_SHOWNORMAL) <= 32 then
      UI_MessageBox(AForm, SOpenFileFailMsg, MB_ICONWARNING or MB_OK);
  end;
end;

end.
