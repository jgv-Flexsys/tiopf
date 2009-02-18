unit frmCityList;

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs,
  model, tiFormMediator, ExtCtrls, Grids, StdCtrls;

type

  TCityListForm = class(TForm)
    BClose: TButton;
    BAdd: TButton;
    BEdit: TButton;
    BDelete: TButton;
    GCities: TStringGrid;
    procedure BAddClick(Sender: TObject);
    procedure BDeleteClick(Sender: TObject);
    procedure BEditClick(Sender: TObject);
  private
    FMediator: TFormMediator;
    FData: TCityList;
    procedure SetData(const AValue: TCityList);
    procedure SetupMediators;
  public
    property Data: TCityList read FData write SetData;
  end;

var
  CityListForm: TCityListForm;

procedure ShowCities(const AList: TCityList);

implementation

{$R *.dfm}

uses
  tiBaseMediator,contactmanager,tiListMediators, frmEditCity;


procedure ShowCities(const AList: TCityList);
var
  frm: TCityListForm;
begin
  frm := TCityListForm.Create(nil);
  try
    frm.Data:=AList;
    frm.ShowModal;
  finally;
    frm.Free;
  end;
end;


{ TCityListForm }

procedure TCityListForm.BEditClick(Sender: TObject);

var
  c: TCity;

begin
  c := TCity(TStringGridMediator(FMediator.FindByComponent(gCities).Mediator).SelectedObject);
  if Assigned(c) then
    if EditCity(c) then
    begin
      // we can save city here
    end;
end;

procedure TCityListForm.BAddClick(Sender: TObject);

var
  c: TCity;

begin
  C:=TCity.Create;
  if EditCity(c) then
    begin
    // we can save country here
    gContactManager.CityList.Add(C);
    end
  else
    c.Free;
end;

procedure TCityListForm.BDeleteClick(Sender: TObject);

var
  c: TCity;
  M : TMediatorView;

begin
  M:=FMediator.FindByComponent(gCities).Mediator;
  c := TCity(TStringGridMediator(M).SelectedObject);
  if Assigned(c) then
    begin
    gContactManager.CityList.Extract(c);
    M.ObjectToGui;
    C.Deleted:=True;
    end;
end;

procedure TCityListForm.SetData(const AValue: TCityList);
begin
  FData:=AValue;
  SetupMediators;
end;

procedure TCityListForm.SetupMediators;
begin
  if not Assigned(FMediator) then
  begin
    FMediator := TFormMediator.Create(self);
    FMediator.AddComposite('Name(110);Zip(80);CountryAsString(150)', gCities);
  end;
  FMediator.Subject := FData;
  FMediator.Active := True;
end;

end.

