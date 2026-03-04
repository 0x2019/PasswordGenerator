unit uAppMenu;

interface

uses
  Winapi.Windows, System.SysUtils, System.Classes, System.IOUtils, Vcl.Forms,
  Vcl.Menus, ShellAPI, Clipbrd;

procedure AppMenu_Update(AForm: TObject);
procedure AppMenu_SaveAs(AForm: TObject);

procedure AppMenu_ClearClipboard(AForm: TObject);

implementation

uses
  uAppStrings, uMain,
  uMenu, uMessageBox;

procedure AppMenu_Update(AForm: TObject);
var
  F: TfrmMain;
begin
  if not (AForm is TfrmMain) then Exit;
  F := TfrmMain(AForm);

  if Assigned(F.miSaveAs) and Assigned(F.mmoResult) then
    F.miSaveAs.Enabled := F.mmoResult.Text <> '';

  UI_Menu_UpdateClipboard(F.miClearClipboard);
end;

procedure AppMenu_ClearClipboard(AForm: TObject);
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
  AppMenu_Update(F);
end;

procedure AppMenu_SaveAs(AForm: TObject);
var
  F: TfrmMain;
  FileName: string;
  Enc: TEncoding;
begin
  if not (AForm is TfrmMain) then Exit;
  F := TfrmMain(AForm);

  if F.mmoResult.Text = '' then Exit;
  if not Assigned(F.sSaveDlg) then Exit;

  F.sSaveDlg.FileName := Format('PG_%s.txt', [FormatDateTime('yyyymmdd_hhnnss', Now)]);

  if not F.sSaveDlg.Execute then Exit;

  FileName := F.sSaveDlg.FileName;
  if ExtractFileExt(FileName) = '' then
    FileName := FileName + '.txt';

  Enc := TUTF8Encoding.Create(False);
  try
    try
      TFile.WriteAllText(FileName, F.mmoResult.Lines.Text, Enc);
    except
      on E: Exception do
      begin
        UI_MessageBox(F, Format(SFileSaveFailMsg, [FileName, E.Message]), MB_ICONERROR or MB_OK);
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

end.
