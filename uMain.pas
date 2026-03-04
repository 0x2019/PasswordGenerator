unit uMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.Classes, System.SysUtils, System.ImageList,
  Vcl.Buttons, Vcl.Controls, Vcl.Forms, Vcl.ImgList, Vcl.Menus, sSkinProvider, sSkinManager,
  acAlphaHints, Vcl.StdCtrls, sBitBtn, sMemo, sEdit, sSpinEdit, sLabel, sCheckBox,
  sGroupBox, acAlphaImageList, Vcl.Dialogs, sDialogs, Vcl.ComCtrls,

  uForms, uMessageBox, uSettings;

type
  TfrmMain = class(TForm)
    sAlphaHints: TsAlphaHints;
    sSkinManager: TsSkinManager;
    sSkinProvider: TsSkinProvider;
    MainMenu: TMainMenu;
    mmuFile: TMenuItem;
    mmuView: TMenuItem;
    mmuTool: TMenuItem;
    mmuHelp: TMenuItem;
    miAbout: TMenuItem;
    btnGenerate: TsBitBtn;
    btnCopy: TsBitBtn;
    btnExit: TsBitBtn;
    grpchar: TsGroupBox;
    chkDigits: TsCheckBox;
    chkLowerCase: TsCheckBox;
    chkUpperCase: TsCheckBox;
    chkSpecialChars: TsCheckBox;
    grpLength: TsGroupBox;
    lblLength: TsLabel;
    grpAffixes: TsGroupBox;
    lblPrefix: TsLabel;
    edtPrefix: TsEdit;
    edtSuffix: TsEdit;
    lblSuffix: TsLabel;
    miClearClipboard: TMenuItem;
    miAlwaysOnTop: TMenuItem;
    sCharImageList: TsCharImageList;
    sCharImageList_Small: TsCharImageList;
    miSaveAs: TMenuItem;
    miExit: TMenuItem;
    sSaveDlg: TsSaveDialog;
    edtLength: TsSpinEdit;
    mmoResult: TsMemo;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure miAboutClick(Sender: TObject);
    procedure miClearClipboardClick(Sender: TObject);
    procedure btnGenerateClick(Sender: TObject);
    procedure btnExitClick(Sender: TObject);
    procedure btnCopyClick(Sender: TObject);
    procedure miAlwaysOnTopClick(Sender: TObject);
    procedure miSaveAsClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
  private
    procedure WMClipboardUpdate(var Msg: TMessage); message WM_CLIPBOARDUPDATE;
  public
    procedure ChangeMessageBoxPosition(var Msg: TMessage); message mbMessage;
    procedure DragForm(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
  end;

var
  frmMain: TfrmMain;

implementation

{$R *.dfm}

uses
  uAppController, uAppMenu, uAppSettings, uAppStrings;

procedure TfrmMain.ChangeMessageBoxPosition(var Msg: TMessage);
begin
  UI_ChangeMessageBoxPosition(Self);
end;

procedure TfrmMain.WMClipboardUpdate(var Msg: TMessage);
begin
  AppMenu_Update(Self);
end;

procedure TfrmMain.DragForm(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  UI_DragForm(Self, Button);
end;

procedure TfrmMain.btnCopyClick(Sender: TObject);
begin
  AppController_Copy(Self);
end;

procedure TfrmMain.btnExitClick(Sender: TObject);
begin
  AppController_Exit(Self);
end;

procedure TfrmMain.btnGenerateClick(Sender: TObject);
begin
  AppController_Generate(Self);
end;

procedure TfrmMain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  RemoveClipboardFormatListener(Handle);
  UI_SaveFormSettings(Self);

  AppSettings_Save(Self);
end;

procedure TfrmMain.FormCreate(Sender: TObject);
begin
  UI_SetMinConstraints(Self);
  UI_LoadFormSettings(Self);

  grpchar.OnMouseDown := DragForm;
  grpLength.OnMouseDown := DragForm;
  grpAffixes.OnMouseDown := DragForm;
  Self.OnMouseDown := DragForm;

  AppSettings_Load(Self);
  UI_SetAlwaysOnTop(Self, miAlwaysOnTop.Checked);

  AppMenu_Update(Self);
  AddClipboardFormatListener(Handle);

  btnGenerate.Click;
end;

procedure TfrmMain.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_ESCAPE then
    AppController_Exit(Self);
end;

procedure TfrmMain.miAboutClick(Sender: TObject);
begin
  AppMenu_About(Self);
end;

procedure TfrmMain.miAlwaysOnTopClick(Sender: TObject);
begin
  AppMenu_AlwaysOnTop(Self);
end;

procedure TfrmMain.miClearClipboardClick(Sender: TObject);
begin
  AppMenu_ClearClipboard(Self);
end;

procedure TfrmMain.miSaveAsClick(Sender: TObject);
begin
  AppMenu_SaveAs(Self);
end;

end.
