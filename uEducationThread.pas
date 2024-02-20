unit uEducationThread;

interface

uses
  Classes, SysUtils,ufirmware;

type  // Режимы обучения
  TMode = ( mBaseFilling, mCorrectinFilling );



   ///касающееся обучения, стационарности и т.п
   type
   Education_data = record
    FlagReadsleep:boolean;//--- флаг разрешения отсчёта
    SleepStacionar_2: integer;//счётчик
    SleepStacionar : integer;//время нахождения в режимной точке, для определения  стационарности
    education_Twat: integer;//температура разрешения обучения
    education_tps : integer;//положение дросселя, выше которого будет происходить обучене
    education_tps_hi:integer;//положение дросселя, выше которого обучение происходить не будет
    education_rpm_lo:integer;//обороты, ниже которых обучение не происходит
    education_rpm_hi:integer;//обороты, выше которых обучение не происходит
    education_BCN : boolean;//Настраивать смесь по ПЦН или БЦН
    //educationCoeff : integer;//множитель коэфицента коррекции
    EducationCoeffLow:integer;//% отклонения коррекции для точного регулирования.
    TCOEFF:integer;//% использования точки для точного регулирования
    education_BCN_ON:boolean;//флаг настройки таблицы бцн
    education_PCN_ON:boolean;//флаг настройки таблицы пцн
    education_FAZA_ON:boolean;//флаг настройки таблицы faza
    count_popad:integer;
    ERROR_COEFF_OLD:real;//ошибка коррекции
    FAZA_NEW:integer;

PCN_RT_OLD:integer;//режимная точка для сравнения
Inter_X,Inter_Y,Inter_RPM16,Inter_TPS16,inter_faza_Y:real;//коэфиценты интерполяции, для вычисления поправки цн
TPS_RT_16,BCN_RT_16,RPM_RT_16,DAD_RT_16,RPM_RT_32,rpm_rt_30,TPS_RT_32,DAD_RT_32:integer;// режимные точки
Table_count_norm: array of array of integer;
Table_Cnock:array [1..16] of array [1..16] of byte;
Table_BCN_data : array [0..255] of array of byte;
Table_PCN_DATA : array of array of byte;//таблица пцн для обучения
Table_FAZA_DATA : array [0..255] of array of byte;
PCN_RT_IN,PCN_RT_OUT:integer;//начало и конец таблицы, а именно номер точки начала и конца
end;

type  // Поток обучения
  TEducationThread = class(TThread)
  private
    FFlag: boolean;
    FDelay: integer;
    //RunFlagExit:boolean;
   // FMinEngineTemp: real;
    //FMinVoltage: real;

    FMode:  TMode;
    //режимная точка
    FWorkX_bcn: integer;
    FWorkY_bcn: integer;
    FWorkX_pcn: integer;
    FWorkY_pcn: integer;
    FWorkX_uoz: integer;
    FWorkY_uoz: integer;
    FWorkX_afr: integer;
    FWorkY_afr: integer;
    FWorkX_faza: integer;
    FWorkY_faza: integer;


    // Определение режимной точки обороты/дроссель
    procedure GetWorkPointPositionRPM_TPS;
    // Обучение
   { Private declarations }
  protected
    procedure Execute; override;
  public
  FMaxEduCount: integer;
    property Flag: boolean read FFlag write FFlag;

    class var Run: boolean;
    educat_data : Education_data;//данные стационарности
    constructor Create( Delay: integer );

    procedure Start( Mode: TMode );  // Запустить режим обучения
    procedure Pause;  // Приостановить режим обучения
    procedure Stop;   // Остановить режим обучения
    procedure ExitThread;  // Завершить работу потока
   // procedure ClearTable;//очистка накопленных данных
    function GenRT(rpm:integer;tps:integer;dad:integer;bcn:integer):integer;
   // function genPcn(Count_X:integer):real;
   // procedure WriteFirmPcn(RT:INTEGER);//запись ПЦН в прошивку
   // procedure generatePcnFirm;
    procedure generatePcnFirm_New;
    procedure generateBCnFirm;
    procedure generateFazaFirm;
    function ReadTableNormCoeff(X:Integer;Y:integer):boolean;
    function ReadCnock(x:integer;Y:integer):boolean;
    property EducationMode: TMode read FMode write FMode;
    property WorkX_bcn: integer read FWorkX_bcn;
    property WorkY_bcn: integer read FWorkY_bcn;
    property WorkX_PCN: integer read FWorkX_PCN;
    property WorkY_PCN: integer read FWorkY_PCN;
    property WorkX_uoz: integer read FWorkX_uoz;
    property WorkY_uoz: integer read FWorkY_uoz;
    property WorkX_afr: integer read FWorkX_afr;
    property WorkY_afr: integer read FWorkY_afr;
    property WorkX_faza: integer read FWorkX_faza;
    property WorkY_faza: integer read FWorkY_faza;

  end;

implementation

uses
  Main;

// Работа потока обучения
constructor TEducationThread.Create(Delay: integer);
begin
  inherited Create();
  FDelay := Delay;
  FMaxEduCount := 10;
  Run := true;
 // Resume;
  educat_data.education_Twat:=60;
  educat_data.education_tps:=1;
  educat_data.education_tps_hi:=100;
  educat_data.education_rpm_lo:=600;
  educat_data.education_rpm_hi:=10200;
  educat_data.SleepStacionar:=30;
  educat_data.ERROR_COEFF_OLD:=0;
end;

//-------------------------- 1 -----------------------------------
procedure TEducationThread.Execute;
begin
  while Run do begin
    sleep( 1 );
//-----------------------------------------------------
 if educat_data.FlagReadsleep then
  inc(educat_data.SleepStacionar_2,1) else //:=educat_data.SleepStacionar_2+1;
  educat_data.SleepStacionar_2:=0;
//-----------------------------------------------------
      if obdii.FlagIsNew then begin//проверяем данные обновились или нет в диагностике
       GetWorkPointPositionRPM_TPS;//запускаем процедуру обучения
      while not obdii.FlagWriteIsNew do break;
       obdii.FlagIsNew:=False; //вешаем флаг, что данные с диагнстики забрали
    end;
  end;
end;

procedure TEducationThread.ExitThread;
begin
if flag then flag:=False;
run:=False;
waitfor;
end;


//----------------------- 2 ---------------------------------------------------
procedure TEducationThread.GetWorkPointPositionRPM_TPS;
var
  RPM: integer;
  TPS: integer;
  PRESS:integer;
  GBC:integer;
  RT,i:integer;
  //RT_FAZA:integer;
  //normcoeff,
  sosed:boolean;
  A,T1,T2,T3,T4:real;
  data_t1_bcn,data_t2_bcn,data_t3_bcn,data_t4_bcn:integer;
  RT1_bcn,RT2_bcn,RT3_bcn,RT4_bcn:integer;
  data_t1_faza,data_t2_faza,data_t3_faza,data_t4_faza:integer;
  RT1_faza,RT2_faza,RT3_faza,RT4_faza:integer;
  data_RT1_PCN,data_RT2_pcn,data_RT3_pcn,data_RT4_pcn:integer;//значение поправки в текущей точке
  RT1_PCN,RT2_pcn,RT3_pcn,RT4_pcn:integer;//номер режимной точки
  AVG_PCN_,AVG_PCN_NEW:real;
   flag_on_education_fuel:boolean;
   error_coeff:real;
begin
RT1_PCN:=0; RT2_PCN:=0; RT3_PCN:=0; RT4_PCN:=0;
RT1_bcn:=0;RT2_bcn:=0;RT3_bcn:=0;RT4_bcn:=0;
 data_t1_faza:=0;
 data_t2_faza:=0;
 data_t3_faza:=0;
 data_t4_faza:=0;
flag_on_education_fuel:=False;
//принимаем данные оборотов, дросселя, давления и наполнения для определения РТ
  RPM := Round( OBDII.FsensorCrankshaftSpeed );
  TPS := Round( OBDII.FsensorThrottlePosition );
  press:=obdii.FsensorPressure;
  GBC:=ROUND( obdii.FsensorAirCycleRate );
  //NormCoeff:=False;
///-------режимные точки на 16
if not mainform.LoadFirmware then  exit;//проверка загруженной прошивки
 RT:=GenRT(RPM,TPS,press,gbc);//определяются режимные точки и коэффициенты интерполяции
 //------------------- коэфицент использования точки для БЦН------------
 T1:=(1-educat_data.Inter_RPM16)*(1-educat_data.Inter_TPS16) ;
 T2:=(educat_data.Inter_RPM16)*(1-educat_data.Inter_TPS16) ;
 T3:=(1-educat_data.Inter_RPM16)*(educat_data.Inter_TPS16) ;
 T4:=(educat_data.Inter_RPM16)*(educat_data.Inter_TPS16) ;
 //------------- режимная точка бцн -------------------------------------
 RT1_bcn:=((FWorkY_bcn-1)*16+FWorkX_bcn)-1;
 RT2_bcn:=((FWorkY_bcn-1)*16+FWorkX_bcn+1)-1;
 RT3_bcn:=((FWorkY_bcn)*16+FWorkX_bcn)-1;
 RT4_bcn:=((FWorkY_bcn)*16+FWorkX_bcn+1)-1;
 //----------- значение бцн из прошивки ----------
 if RT1_bcn >=0 then
  data_t1_bcn:=firmware.FFirmwareData[bcn_data.Addr+RT1_bcn];
 if RT2_bcn >0 then
  data_t2_bcn:=firmware.FFirmwareData[bcn_data.Addr+RT2_bcn];
 if RT3_bcn >0 then
  data_t3_bcn:=firmware.FFirmwareData[bcn_data.Addr+RT3_bcn];
 if RT4_bcn >0 then
  data_t4_bcn:=firmware.FFirmwareData[bcn_data.Addr+RT4_bcn];
  //----- Новое значение БЦН каждой точки
  data_t1_bcn:=Round(data_t1_bcn+(OBDii.FsensorAirCycleRate*obdii.FsensorFuelTimeCorrection/bcn_data.mnozitel*3 -  data_t1_bcn)*T1);
  data_t2_bcn:=Round(data_t2_bcn+(OBDii.FsensorAirCycleRate*obdii.FsensorFuelTimeCorrection/bcn_data.mnozitel*3 -  data_t2_bcn)*T2);
  data_t3_bcn:=round(data_t3_bcn+(OBDii.FsensorAirCycleRate*obdii.FsensorFuelTimeCorrection/bcn_data.mnozitel*3 -  data_t3_bcn)*T3);
  data_t4_bcn:=round(data_t4_bcn+(OBDii.FsensorAirCycleRate*obdii.FsensorFuelTimeCorrection/bcn_data.mnozitel*3 -  data_t4_bcn)*T4);
  if data_t1_bcn > 255 then data_t1_bcn:=255;
  if data_t2_bcn > 255 then data_t2_bcn:=255;
  if data_t3_bcn > 255 then data_t3_bcn:=255;
  if data_t4_bcn > 255 then data_t4_bcn:=255;
 ///--------работа с фазой ------------------------------------
 if faza_data.Addr <> 0 then  begin
 T1:=(1-educat_data.Inter_RPM16)*(1-educat_data.inter_faza_Y) ;
 T2:=(educat_data.Inter_RPM16)*(1-educat_data.inter_faza_Y) ;
 T3:=(1-educat_data.Inter_RPM16)*(educat_data.inter_faza_Y) ;
 T4:=(educat_data.Inter_RPM16)*(educat_data.inter_faza_Y) ;
 //------------- режимная точка faza ------------------------------------- 4
 RT1_faza:=((FWorkY_faza-1)*16+FWorkX_faza)-1;
 RT2_faza:=((FWorkY_faza-1)*16+FWorkX_faza+1)-1;
 RT3_faza:=((FWorkY_faza)*16+FWorkX_faza)-1;
 RT4_faza:=((FWorkY_faza)*16+FWorkX_faza+1)-1;
 //-------- фаза из прошивки для каждой точки
  data_t1_faza:=firmware.FFirmwareData[faza_data.Addr+RT1_faza];
  data_t2_faza:=firmware.FFirmwareData[faza_data.Addr+RT2_faza];
  data_t3_faza:=firmware.FFirmwareData[faza_data.Addr+RT3_faza];
  data_t4_faza:=firmware.FFirmwareData[faza_data.Addr+RT4_faza];
 if faza_data.mnozitel<>0 then
  A:= round(obdii.FsensorGenFaza/faza_data.mnozitel);
  data_t1_faza:=Round(data_t1_faza+(A -  data_t1_faza)*T1);
  data_t2_faza:=Round(data_t2_faza+(A -  data_t2_faza)*T2);
  data_t3_faza:=round(data_t3_faza+(A -  data_t3_faza)*T3);
  data_t4_faza:=round(data_t4_faza+(A -  data_t4_faza)*T4);
  if data_t1_faza > 254 then data_t1_faza:=254;
  if data_t2_faza > 254 then data_t2_faza:=254;
  if data_t3_faza > 254 then data_t3_faza:=254;
  if data_t4_faza > 254 then data_t4_faza:=254;
 end;
 //----определяем РТ точки в прошивке  RT1_PCN..RT4_PCN
 RT1_PCN:=((FWorkY_pcn - 1) * pcn_data.RPM_count + FWorkX_pcn ) - 1;
 RT2_PCN:=((FWorkY_pcn - 1) * pcn_data.RPM_count + FWorkX_pcn + 1 ) - 1;
 RT3_PCN:=((FWorkY_pcn) * pcn_data.RPM_count + FWorkX_pcn ) - 1;
 RT4_PCN:=((FWorkY_pcn) * pcn_data.RPM_count + FWorkX_pcn + 1 ) - 1;
  //---коэфициент использования точки
 T1:=(1-educat_data.Inter_X)*(1-educat_data.Inter_Y);
 T2:=educat_data.Inter_X*(1-educat_data.Inter_Y);
 T3:=(1-educat_data.Inter_X)*educat_data.Inter_Y;
 T4:=educat_data.Inter_X*educat_data.Inter_Y;
 //----значение поправки в hex из прошивки
 if pcn_data.Addr > 0 then begin
   if RT1_PCN >= 0 then
 data_RT1_PCN:=firmware.FFirmwareData[pcn_data.Addr+RT1_PCN];
 if RT2_PCN > 0 then
 data_RT2_PCN:=firmware.FFirmwareData[pcn_data.Addr+RT2_PCN];
 if RT3_PCN > 0 then
 data_RT3_PCN:=firmware.FFirmwareData[pcn_data.Addr+RT3_PCN];
 if RT4_PCN > 0 then
 data_RT4_PCN:=firmware.FFirmwareData[pcn_data.Addr+RT4_PCN];
 AVG_PCN_NEW:=(data_RT1_PCN*T1+data_RT2_PCN*T2+data_RT3_PCN*T3+data_RT4_PCN*T4);
 end;
 //-----------------------
 //текущая ошибка =  obdii.FsensorFuelTimeCorrection - 1;    1.05-1=0.05
 //общая ошибка =  старая + новая
 //0.05 + 0.02 = 0.07
 error_coeff:=0;
 if educat_data.ERROR_COEFF_OLD <> 0 then
 error_coeff:=obdii.FsensorFuelTimeCorrection - 1 + educat_data.ERROR_COEFF_OLD;
 if error_coeff > 0.1 then error_coeff:=0.1;
 if error_coeff < -0.1 then error_coeff:=-0.1;
 AVG_PCN_:=AVG_PCN_NEW*(obdii.FsensorFuelTimeCorrection+error_coeff);
 if AVG_PCN_ > 255 then AVG_PCN_:=255;

 {if obdii.FsensorFuelTimeCorrection > 1 then begin
 if (obdii.FsensorFuelTimeCorrection - 1) / 0.05 > 1 then
 AVG_PCN_:=AVG_PCN_NEW*obdii.FsensorFuelTimeCorrection * ( 1 + educat_data.educationCoeff / 100 )
  else
 AVG_PCN_:=AVG_PCN_NEW*obdii.FsensorFuelTimeCorrection * ( 1 + ( educat_data.educationCoeff / 100 * ((obdii.FsensorFuelTimeCorrection - 1) / 0.05) ) )
 end;
if obdii.FsensorFuelTimeCorrection < 1 then begin
 if (1 - obdii.FsensorFuelTimeCorrection ) / 0.05 > 1 then
 AVG_PCN_:=AVG_PCN_NEW*obdii.FsensorFuelTimeCorrection * (1 - educat_data.educationCoeff / 100 )
 else
  AVG_PCN_:=AVG_PCN_NEW*obdii.FsensorFuelTimeCorrection * (1 - educat_data.educationCoeff / 100 ) * ( (1 - obdii.FsensorFuelTimeCorrection)/0.05);
 end;
 }
 //--------------------------

 //---теперь нужно интерполяцией раскидать новую поправку
 if ((1 - (educat_data.EducationCoeffLow / 100)) < obdii.FsensorFuelTimeCorrection) and ((1 + (educat_data.EducationCoeffLow / 100)) > obdii.FsensorFuelTimeCorrection) then
begin
if  obdii.FsensorFuelTimeCorrection > 1 then  begin
 inc(data_RT1_PCN,1);
 inc(data_RT2_PCN,1);
 inc(data_RT3_PCN,1);
 inc(data_RT4_PCN,1);
end;
if  obdii.FsensorFuelTimeCorrection < 1 then  begin
 dec(data_RT1_PCN,1);
 dec(data_RT2_PCN,1);
 dec(data_RT3_PCN,1);
 dec(data_RT4_PCN,1);
end;

end else begin
if T1 > 0.5 then
 data_RT1_PCN:=Round( AVG_PCN_NEW * obdii.FsensorFuelTimeCorrection ) else
 data_RT1_PCN:=Round( data_RT1_PCN + ( AVG_PCN_ - data_RT1_PCN ) * T1 );
if T2 > 0.5 then data_RT2_PCN:=Round( AVG_PCN_NEW * obdii.FsensorFuelTimeCorrection )  else
 data_RT2_PCN:=Round( data_RT2_PCN + ( AVG_PCN_ - data_RT2_PCN ) * T2 );
if T3 > 0.5 then data_RT3_PCN:=Round( AVG_PCN_NEW * obdii.FsensorFuelTimeCorrection )  else
 data_RT3_PCN:=Round( data_RT3_PCN + ( AVG_PCN_ - data_RT3_PCN ) * T3 );
if T4 > 0.5 then data_RT4_PCN:=Round( AVG_PCN_NEW * obdii.FsensorFuelTimeCorrection )  else
 data_RT4_PCN:=Round( data_RT4_PCN + ( AVG_PCN_ - data_RT4_PCN ) * T4 );
 //90 85 75 80 (30% 20% 40% 10%) avg_=90*0.3+85*0.2+75*0.4+80*0.1=82*1.05(86)
 //88 85 79 81
 //26+17+32+8=83
 //co был 1,05 а стал 1,02. ошибка = стар - нов = 0,03
end;
 //------ проверяем размер массива, для записи новой поправки цн
if length( educat_data.Table_PCN_DATA ) <> pcn_data.load_count*Pcn_data.RPM_count then
 setlength(educat_data.Table_PCN_DATA,pcn_data.load_count*Pcn_data.RPM_count);
 //----------------------------------------------------------------
 //RT_FAZA:=(FWorkY_faza - 1) * faza_data.RPM_count + FWorkX_faza;
 //---- короче, здесь по ходу таблица для закраски кноков
 //if obdii.FsensotKNOCkVoltage - obdii.Fsensor_AVG_ADC_KNOCK > 1.7 then
 //таблица кноков
 if (obdii.flag_zona_knock = 1) and (obdii.flag_knock = 1) then begin
 inc(educat_data.Table_Cnock[FWorkX_uoz,FWorkY_uoz],1);
 if educat_data.Table_Cnock[FWorkX_uoz,FWorkY_uoz] > 10 then
   educat_data.Table_Cnock[FWorkX_uoz,FWorkY_uoz]:=10;
 end;

//-------- расчёт нового БЦН -----------
 obdii.pcn_gen:=AVG_PCN_NEW;
 obdii.new_pcn:=obdii.pcn_gen*obdii.FsensorFuelTimeCorrection;
//-------------------------------------------------------------------------------------------------------------------------------------
//---------
if not FFlag then exit;//проверка флага разрешения обучения

  if educat_data.FlagReadsleep = false then begin
   educat_data.SleepStacionar_2:=0;
   educat_data.count_popad:=0;

  end;{
//определяем с какой задержкой будет работать, после перезаписи
if RPM <=  1500 then educat_data.SleepStacionar:=5;
if (RPM >  1500) and (RPM < 3000) then educat_data.SleepStacionar:=5;
if RPM >= 3000 then educat_data.SleepStacionar:=5;
if obdii.FsensorThrottlePosition>=90 then begin
 educat_data.SleepStacionar:=2;
 FMaxEduCount:=3;//количество попаданий для обучения
end; }
if (obdii.FsensorCoeffCorrGTC_HI > 0)// or (obdii.FsensorCoeffCorrGTC_LO > 0)
 then exit;

//------------------ ЗАПИСЫВАЕМ ЗНАЧЕНИЕ В ТАБЛИЦУ ДЛЯ ЗАКРАСКИ, ЕСЛИ КОЭФИЦЕНТ НОРМАЛЬНЫЙ ----------
      if length(educat_data.Table_count_norm) > 0 then begin
       if (obdii.FsensorFuelTimeCorrection <= 1.05) and (obdii.FsensorFuelTimeCorrection >= 0.95) then begin
       // FMaxEduCount:=10;//количество попаданий для обучения
        if educat_data.Table_count_norm[FWorkX_pcn,FWorkY_pcn] < 30 then
          inc(educat_data.Table_count_norm[FWorkX_pcn,FWorkY_pcn],1);
       end else begin
      // FMaxEduCount:=3;//количество попаданий для обучения
        educat_data.Table_count_norm[FWorkX_pcn,FWorkY_pcn]:=0;
       end;
      end;

//------- здесь проверка стационарности и т.п
 if educat_data.SleepStacionar_2 < educat_data.SleepStacionar  then exit;
    if obdii.FsensorCoolantTemp < educat_data.education_Twat then exit;
    if obdii.FsensorCrankshaftSpeed < educat_data.education_rpm_lo then exit;
    if obdii.FsensorCrankshaftSpeed > educat_data.education_rpm_hi then exit;
    if obdii.flag_fuelOFF = 1 then exit;
    if obdii.FsensorThrottlePosition < educat_data.education_tps then exit;
    if obdii.FsensorThrottlePosition > educat_data.education_tps_hi then exit;
    if obdii.FsensorFuelTimeCorrection = 1 then  flag_on_education_fuel:=true;
    educat_data.FlagReadsleep:=False;
    //-------------ЗАПИСЫВАЕМ ЗНАЧЕНИЯ ФАЗЫ ВПРЫСКА----------------------
    if faza_data.Addr > 0 then  begin
    setlength(educat_data.Table_FAZA_DATA[RT1_FAZA],length(educat_data.Table_FAZA_DATA[RT1_FAZA])+1);
    educat_data.Table_FAZA_DATA[RT1_FAZA][length(educat_data.Table_FAZA_DATA[RT1_FAZA])- 1] :=data_t1_faza;
    if RT2_FAZA <= 255 then  begin
    setlength(educat_data.Table_FAZA_DATA[RT2_FAZA],length(educat_data.Table_FAZA_DATA[RT2_FAZA])+1);
    educat_data.Table_FAZA_DATA[RT2_FAZA][length(educat_data.Table_FAZA_DATA[RT2_FAZA]) - 1] :=data_t2_faza;
    end;
    if RT3_faza <=255 then begin
    setlength(educat_data.Table_FAZA_DATA[RT3_FAZA],length(educat_data.Table_FAZA_DATA[RT3_FAZA])+1);
    educat_data.Table_FAZA_DATA[RT3_FAZA][length(educat_data.Table_FAZA_DATA[RT3_FAZA]) - 1] :=data_t3_faza;
    end;
    if RT4_faza <=255 then begin
    setlength(educat_data.Table_FAZA_DATA[RT4_FAZA],length(educat_data.Table_FAZA_DATA[RT4_FAZA])+1);
    educat_data.Table_FAZA_DATA[RT4_FAZA][length(educat_data.Table_FAZA_DATA[RT4_FAZA]) - 1] :=data_t4_faza;
    end;
    end;
    //------ ЗАПИСЫВАЕМ ЗНАЧЕНИЯ НОВОГО БЦН В МАССИВ ----------------------
    setlength(educat_data.Table_BCN_data[RT1_BCN],length(educat_data.Table_BCN_data[RT1_BCN])+1);
    educat_data.Table_BCN_data[RT1_BCN][length(educat_data.Table_BCN_data[RT1_BCN])-1]:=data_t1_bcn;
    if self.FWorkX_bcn < 16 then begin
    setlength(educat_data.Table_BCN_data[RT2_BCN],length(educat_data.Table_BCN_data[RT2_BCN])+1);
    educat_data.Table_BCN_data[RT2_BCN][length(educat_data.Table_BCN_data[RT2_BCN])-1]:=data_t2_bcn;
    end;
    if self.FWorkY_bcn < 16 then begin
    setlength(educat_data.Table_BCN_data[RT3_BCN],length(educat_data.Table_BCN_data[RT3_BCN])+1);
    educat_data.Table_BCN_data[RT3_BCN][length(educat_data.Table_BCN_data[RT3_BCN])-1]:=data_t3_bcn;
    end;
    if (FWorkY_bcn < 16) and (FWorkX_bcn < 16) then begin
    setlength(educat_data.Table_BCN_data[RT4_BCN],length(educat_data.Table_BCN_data[RT4_BCN])+1);
    educat_data.Table_BCN_data[RT4_BCN][length(educat_data.Table_BCN_data[RT4_BCN])-1]:=data_t4_bcn;
    end;
    //--- end bcn ----
if not flag_on_education_fuel then
if ((1 - (educat_data.EducationCoeffLow / 100)) < obdii.FsensorFuelTimeCorrection) and ((1 + (educat_data.EducationCoeffLow / 100)) > obdii.FsensorFuelTimeCorrection) then
begin
 //--------------- точная настройка ------
 if RT1_PCN >= 0 then

   if round(T1*100)>=educat_data.TCOEFF then begin
   setlength(educat_data.Table_PCN_DATA[RT1_PCN],length( educat_data.Table_PCN_DATA[RT1_PCN])+1);
   educat_data.Table_PCN_DATA[RT1_PCN][length( educat_data.Table_PCN_DATA[RT1_PCN])-1]:=lo(data_RT1_PCN);//round(firmware.FFirmwareData[pcn_data.Addr+RT1_PCN]*obdii.FsensorFuelTimeCorrection);
   end;
   if RT2_PCN >0 then

   if round(T2*100)>=educat_data.TCOEFF then begin
   if RT2_PCN < pcn_data.RPM_count*pcn_data.load_count - 1 then begin
   setlength(educat_data.Table_PCN_DATA[RT2_PCN],length( educat_data.Table_PCN_DATA[RT2_PCN])+1);
   educat_data.Table_PCN_DATA[RT2_PCN][length( educat_data.Table_PCN_DATA[RT2_PCN])-1]:=lo(data_RT2_PCN);//round(firmware.FFirmwareData[pcn_data.Addr+RT2_PCN]*obdii.FsensorFuelTimeCorrection);
   end;
   end;
   if RT3_PCN > 0 then

   if round(T3*100)>=educat_data.TCOEFF then begin
   if RT3_PCN < pcn_data.RPM_count*pcn_data.load_count - 1 then begin
   setlength(educat_data.Table_PCN_DATA[RT3_PCN],length( educat_data.Table_PCN_DATA[RT3_PCN])+1);
   educat_data.Table_PCN_DATA[RT3_PCN][length( educat_data.Table_PCN_DATA[RT3_PCN])-1]:=lo(data_RT3_PCN);//round(firmware.FFirmwareData[pcn_data.Addr+RT3_PCN]*obdii.FsensorFuelTimeCorrection);
   end;
   end;
   if RT3_PCN > 0 then

   if round(T4*100)>=educat_data.TCOEFF then begin
   if RT4_PCN < pcn_data.RPM_count*pcn_data.load_count - 1 then begin
   setlength(educat_data.Table_PCN_DATA[RT4_PCN],length( educat_data.Table_PCN_DATA[RT4_PCN])+1);
   educat_data.Table_PCN_DATA[RT4_PCN][length( educat_data.Table_PCN_DATA[RT4_PCN])-1]:=lo(data_RT4_PCN);//round(firmware.FFirmwareData[pcn_data.Addr+RT4_PCN]*obdii.FsensorFuelTimeCorrection);
   end;
   end;

end else begin
  //----- грубая настройка ------------
     setlength(educat_data.Table_PCN_DATA[RT1_PCN],length( educat_data.Table_PCN_DATA[RT1_PCN])+1);
   educat_data.Table_PCN_DATA[RT1_PCN][length( educat_data.Table_PCN_DATA[RT1_PCN])-1]:=lo(data_RT1_PCN);

   if RT2_PCN < pcn_data.RPM_count*pcn_data.load_count - 1 then begin
   setlength(educat_data.Table_PCN_DATA[RT2_PCN],length( educat_data.Table_PCN_DATA[RT2_PCN])+1);
   educat_data.Table_PCN_DATA[RT2_PCN][length( educat_data.Table_PCN_DATA[RT2_PCN])-1]:=LO(data_RT2_PCN);
   end;

   if RT3_PCN < pcn_data.RPM_count*pcn_data.load_count - 1 then begin
   setlength(educat_data.Table_PCN_DATA[RT3_PCN],length( educat_data.Table_PCN_DATA[RT3_PCN])+1);
   educat_data.Table_PCN_DATA[RT3_PCN][length( educat_data.Table_PCN_DATA[RT3_PCN])-1]:=lo(data_RT3_PCN);
   end;

   if RT4_PCN < pcn_data.RPM_count*pcn_data.load_count - 1 then begin
   setlength(educat_data.Table_PCN_DATA[RT4_PCN],length( educat_data.Table_PCN_DATA[RT4_PCN])+1);
   educat_data.Table_PCN_DATA[RT4_PCN][length( educat_data.Table_PCN_DATA[RT4_PCN])-1]:=lo(data_RT4_PCN);
   end;
end;
//----------------- pcn -----------------------------------------------
   inc(educat_data.count_popad,1);
//----------- перезапись эбу ------------------------------------------------------------------
     //----определение количества попаданий в точку
  if educat_data.count_popad >= FMaxEduCount then begin
  //присваиваем значение ошибки старому
  educat_data.ERROR_COEFF_OLD:=obdii.FsensorFuelTimeCorrection - 1;
  //сперва нужно расчитать все поправки
 if educat_data.education_BCN_ON then generateBCnFirm;
  //------ теперь переписывем таблицы в  прошивку
if educat_data.education_PCN_ON then generatePcnFirm_New;
//расчёт фазы впрыска
if educat_data.education_FAZA_ON then generateFazaFirm;

  //--- ---------теперь записываем пцн в эбу ------------------------------------
   if educat_data.education_PCN_ON then begin
   if (educat_data.PCN_RT_OUT > 0) or (educat_data.PCN_RT_IN > 0) then begin
    setlength(obdii.TableOLT,educat_data.PCN_RT_OUT-educat_data.PCN_RT_IN + 1);
    obdii.StartAddrTableOLT:=pcn_data.Addr+educat_data.PCN_RT_IN;
    for I := 0 to ( educat_data.PCN_RT_OUT-educat_data.PCN_RT_IN ) do
    obdii.TableOLT[i]:=firmware.FFirmwareData[pcn_data.Addr+i+educat_data.PCN_RT_IN];
    obdii.FlagRewraiteTableOLT:=true;
   end;
   end;

  //------------------ перезапись бцн в эбу ----------------------------------------------------
   if  educat_data.education_BCN_ON then begin
    setlength(obdii.TableBCN,bcn_data.load_count*bcn_data.RPM_count);
    obdii.SatartAddrBCN:=bcn_data.Addr;
   for I := 0 to bcn_data.load_count*bcn_data.RPM_count - 1 do
    obdii.TableBCN[i]:=firmware.FFirmwareData[bcn_data.Addr+i];
    obdii.FlagRewraiteTableBCN:=true;
   end;
 //----------------ПЕРЕЗАПИСЬ ФАЗЫ В ЭБУ--------------------------
 if educat_data.education_FAZA_ON then
   if faza_data.Addr > 0 then BEGIN
    setlength(obdii.TableFAZA,256);
    for i := 0 to 255 do obdii.TableFAZA[i]:=firmware.FFirmwareData[faza_data.Addr+i];
     obdii.SatartAddrfaza:=faza_data.Addr;
     obdii.FlagRewraiteTableFAZA:=true;
     firmware.GetTable(mainform.SG_FAZA,faza_data.Addr,1,faza_data.mnozitel,faza_data.Сount,0);
     end;
//----------------------------------------------------------------
    //перезагружаем таблицу в программе
    firmware.GetTable(mainform.SG_PCN,pcn_data.Addr,128,1,pcn_DATA.Сount,0);
    firmware.GetTable(mainform.SG_BCN,bcn_data.Addr,3,bcn_data.mnozitel,bcn_data.Сount,0);
    if pcn_data.Addr = series_data.addr then
      firmware.GetTable(mainform.SG_OLT,series_data.addr,128,1,(series_data.Load_Count*series_data.RPM_COUNT)-1,0);
    if bcn_data.Addr = series_data.addr then
       firmware.GetTable(mainform.SG_OLT,series_data.addr,3,bcn_data.mnozitel,(series_data.Load_Count*series_data.RPM_COUNT)-1,0);
   //очищаем накопленные данные масивов

     //сбрасываем счётчик перезаписи
     educat_data.SleepStacionar_2:=0;
     educat_data.count_popad:=0;
     educat_data.FlagReadsleep:=true;
  end;
//-------- конец перезаписи эбу -------------------------------------------------------------
end;

procedure TEducationThread.Start( Mode: TMode );
begin
  EducationMode := Mode;
  // Обнуляем таблицу режимных точек и собранные данные

  // Вешаем флаг разрешения обучения
  FFlag := true;
end;

procedure TEducationThread.Pause;
begin
  if FFlag then
    FFlag := false
  else
    FFlag := true;
end;

procedure TEducationThread.Stop;
begin
  FFlag := false;
end;


//-------------------- 4 ----------------------------------------------------

//определение РТ и коэфицентов интерполяции
function teducationThread.GenRT(rpm: Integer; tps: Integer; dad: Integer;bcn:integer) :integer;
var
I:integer;
RT_X,RT_Y,RT:integer;
Coeff_X,Coeff_Y:real;
begin
RT_X:=0; RT_Y:=0; Coeff_X:=0; Coeff_Y:=0;
///------- ПРОВЕРКА РАЗМЕРА ТРЁХМЕРНОГО МАССИВА ДЛЯ ЗАКРАСКИ ТАБЛИЦЫ -----------
if length(educat_data.Table_count_norm)>0 then begin
 if length(educat_data.Table_count_norm) <> pcn_data.RPM_count+1 then begin
  setlength(educat_data.Table_count_norm,0,0);
  setlength(educat_data.Table_count_norm,pcn_data.RPM_count+1,pcn_data.load_count+1);
 end;
 if length(educat_data.Table_count_norm[0])<>pcn_data.load_count+1 then begin
  setlength(educat_data.Table_count_norm,0,0);
  setlength(educat_data.Table_count_norm,pcn_data.RPM_count+1,pcn_data.load_count+1);
 end;
end else setlength(educat_data.Table_count_norm,pcn_data.RPM_count+1,pcn_data.load_count+1);
//----------------- ОБЩЕЕ ОПРЕДЕЛЕНИЕ РТ ----------------------
 educat_data.rpm_rt_30:=(rpm+30)div 30  ;
for i := 1 to 32 do begin
 //---RT_16
 if I <= 16 then begin
  if RPM >= firmware.FRPMAxis[i]     then  educat_data.RPM_RT_16:=i;
  if TPS >= firmware.FThrottleAxis[i] then educat_data.TPS_RT_16:=i;
  if dad >= firmware.FDADAxis[i]     then  educat_data.DAD_RT_16:=i;
  if bcn >= firmware.FBCNAxis[i]     then  educat_data.BCN_RT_16:=i;
 end;
//---RT_32
 if i <= 31 then begin
  if RPM >= firmware.FRPMAxis_32[i]     then  educat_data.RPM_RT_32:=i;
  if TPS >= firmware.FThrottleAxis_32[i] then educat_data.TPS_RT_32:=i;
 end;
 if dad >= firmware.FdadAxis_32[i]     then  educat_data.DAD_RT_32:=i;
end;

if RPM <= firmware.FRPMAxis[1] then  educat_data.RPM_RT_16:=1;
if TPS <= firmware.FThrottleAxis[1] then  educat_data.TPS_RT_16:=1;
if DAD <= firmware.FDADAxis[1] then  educat_data.DAD_RT_16:=1;
if bcn <= firmware.FBCNAxis[1] then  educat_data.BCN_RT_16:=1;


if RPM <= firmware.FRPMAxis_32[1] then  educat_data.RPM_RT_32:=1;
if TPS <= firmware.FThrottleAxis_32[1] then  educat_data.TPS_RT_32:=1;
if DAD <= firmware.FdadAxis_32[1] then  educat_data.DAD_RT_32:=1;
//--------------- обороты ----------------------------------------------------------
if pcn_data.RPM_count = 16 then begin
 RT_X:=educat_data.RPM_RT_16;
  if (RPM >= firmware.FRPMAxis[1]) and (RPM < firmware.FRPMAxis[16]) then
   Coeff_X:=(RPM - firmware.FRPMAxis[RT_X])/(firmware.FRPMAxis[RT_X+1] - firmware.FRPMAxis[RT_X]) else
   Coeff_X:=0;
end;

if pcn_data.RPM_count = 32 then begin
 RT_X:=educat_data.RPM_RT_32;
  if (RPM >= firmware.FRPMAxis_32[1]) and (RPM < firmware.FRPMAxis_32[31]) then
  Coeff_X:=(RPM - firmware.FRPMAxis_32[RT_X])/(firmware.FRPMAxis_32[RT_X+1] - firmware.FRPMAxis_32[RT_X]) else
  Coeff_X:=0;
end;
//---- коэфиценты интерполяции общие -------------------------------------------
 if (RPM >= firmware.FRPMAxis[1]) and (RPM < firmware.FRPMAxis[16]) then
   educat_data.Inter_RPM16:=(RPM - firmware.FRPMAxis[educat_data.RPM_RT_16])/(firmware.FRPMAxis[educat_data.RPM_RT_16+1] - firmware.FRPMAxis[educat_data.RPM_RT_16]) else
   educat_data.Inter_RPM16:=0;
 if (TPS > firmware.FThrottleAxis[1]) and (TPS < firmware.FThrottleAxis[16])  then
  educat_data.Inter_TPS16:=(TPS - firmware.FThrottleAxis[educat_data.TPS_RT_16])/(firmware.FThrottleAxis[educat_data.TPS_RT_16+1] - firmware.FThrottleAxis[educat_data.TPS_RT_16]) else
  educat_data.Inter_TPS16:=0;
//-------------------- дроссель/давление на 16 для пцн ---------------------------------------------------------
if pcn_data.load_count = 16 then begin
 if pcn_data.TPS then begin
  RT_Y:=educat_data.TPS_RT_16;
  if (TPS > firmware.FThrottleAxis[1]) and (TPS < firmware.FThrottleAxis[16])  then
  Coeff_Y:=(TPS - firmware.FThrottleAxis[RT_Y])/(firmware.FThrottleAxis[RT_Y+1] - firmware.FThrottleAxis[RT_Y]) else
  Coeff_Y:=0;
 end;
 if pcn_data.dad then begin
  RT_Y:=educat_data.DAD_RT_16;
  if (DAD > firmware.FDADAxis[1]) and ( DAD < firmware.FDADAxis[16]) then
  Coeff_Y:=(DAD - firmware.FDADAxis[RT_Y])/(firmware.FDADAxis[RT_Y+1]-firmware.FDADAxis[RT_Y]) else
  Coeff_Y:=0;
 end;
end;
//-----------------
if FAZA_DATA.load_count = 16 then BEGIN
  if faza_data.BCN then  begin
  RT_Y:=educat_data.BCN_RT_16;
  if (bcn > firmware.FBCNAxis[1]) and ( bcn < firmware.FBCNAxis[16]) then
  educat_data.inter_faza_Y:=(bcn - firmware.FBCNAxis[RT_Y])/(firmware.FBCNAxis[RT_Y+1]-firmware.FBCNAxis[RT_Y]) else
  educat_data.inter_faza_Y:=0;
  end;
  if faza_data.dad then begin
  RT_Y:=educat_data.DAD_RT_16;
  if (DAD > firmware.FDADAxis[1]) and ( DAD < firmware.FDADAxis[16]) then
  educat_data.inter_faza_Y:=(DAD - firmware.FDADAxis[RT_Y])/(firmware.FDADAxis[RT_Y+1]-firmware.FDADAxis[RT_Y]) else
  educat_data.inter_faza_Y:=0;
  end;

END;

//-------------------- дроссель/давление на 32  --------------------------------------------------------
if pcn_data.load_count = 32 then begin
 if pcn_data.TPS then begin
  RT_Y:=educat_data.TPS_RT_32;
  if (TPS >firmware.FThrottleAxis_32[1]) and (TPS < firmware.FThrottleAxis_32[31]) then
  Coeff_Y:=(TPS - firmware.FThrottleAxis_32[RT_Y])/(firmware.FThrottleAxis_32[RT_Y+1]-firmware.FThrottleAxis_32[RT_Y])
  else
  Coeff_Y:=0;
 end;
 if pcn_data.dad then begin
  RT_Y:=educat_data.DAD_RT_32;
  if (DAD > firmware.FdadAxis_32[1]) and (dad < firmware.FdadAxis_32[32])  then
   Coeff_Y:=(dad- firmware.FdadAxis_32[RT_Y])/(firmware.FdadAxis_32[RT_Y+1] - firmware.FdadAxis_32[RT_Y] )
 end;
end;
//------------------------ определение режимной точки -----------------------------------------------------
RT:=(RT_Y-1)*pcn_data.RPM_count+RT_X;
//------запись РТ и коэфицентов
if RT<>educat_data.PCN_RT_OLD then educat_data.FlagReadsleep:=False else educat_data.FlagReadsleep:=true;
educat_data.PCN_RT_OLD:=RT;//режимная точка для сравнения
educat_data.Inter_X:=Coeff_X;//коэфиценты интерполяции, для вычисления поправки цн
educat_data.Inter_Y:=Coeff_Y;//коэфиценты интерполяции, для вычисления поправки цн

//---------- RT_BCN ------------------
if bcn_data.RPM_count = 16 then self.FWorkX_bcn:=EDUCAT_DATA.RPM_RT_16;
if bcn_data.RPM_count = 32 then self.FWorkX_bcn:=EDUCAT_DATA.RPM_RT_32;
if bcn_data.load_count = 16 then begin
  if bcn_data.dad then self.FWorkY_bcn:=EDUCAT_DATA.DAD_RT_16;
  if bcn_data.TPS then self.FWorkY_bcn:=EDUCAT_DATA.TPS_RT_16;
end;
if bcn_data.load_count = 32 then begin
  if bcn_data.dad then self.FWorkY_bcn:=EDUCAT_DATA.DAD_RT_32;
  if bcn_data.TPS then self.FWorkY_bcn:=EDUCAT_DATA.TPS_RT_32;
end;
//--------- RT_PCN ------------------------
if PCN_data.RPM_count = 16 then self.FWorkX_PCN:=EDUCAT_DATA.RPM_RT_16;
if PCN_data.RPM_count = 32 then self.FWorkX_PCN:=EDUCAT_DATA.RPM_RT_32;
if PCN_data.load_count = 16 then begin
  if PCN_data.dad then self.FWorkY_PCN:=EDUCAT_DATA.DAD_RT_16;
  if PCN_data.TPS then self.FWorkY_PCN:=EDUCAT_DATA.TPS_RT_16;
end;
if PCN_data.load_count = 32 then begin
  if PCN_data.dad then self.FWorkY_PCN:=EDUCAT_DATA.DAD_RT_32;
  if PCN_data.TPS then self.FWorkY_PCN:=EDUCAT_DATA.TPS_RT_32;
end;
//---------- uoz ------------------------------
if uoz_data.RPM_count = 16 then self.FWorkX_uoz:=EDUCAT_DATA.RPM_RT_16;
if uoz_data.RPM_count = 32 then self.FWorkX_uoz:=EDUCAT_DATA.RPM_RT_32;
if uoz_data.load_count = 16 then begin
  if uoz_data.dad then self.FWorkY_uoz:=EDUCAT_DATA.DAD_RT_16;
  if uoz_data.TPS then self.FWorkY_uoz:=EDUCAT_DATA.TPS_RT_16;
  if uoz_data.BCN then self.FWorkY_uoz:=EDUCAT_DATA.bcn_rt_16;

end;
if uoz_data.load_count = 32 then begin
  if uoz_data.dad then self.FWorkY_uoz:=EDUCAT_DATA.DAD_RT_32;
  if uoz_data.TPS then self.FWorkY_uoz:=EDUCAT_DATA.TPS_RT_32;
end;
//---------------- afr -------------------------
if afr_data.RPM_count = 16 then self.FWorkX_afr:=EDUCAT_DATA.RPM_RT_16;
if afr_data.RPM_count = 32 then self.FWorkX_afr:=EDUCAT_DATA.RPM_RT_32;
if afr_data.load_count = 16 then begin
  if afr_data.dad then self.FWorkY_afr:=EDUCAT_DATA.DAD_RT_16;
  if afr_data.TPS then self.FWorkY_afr:=EDUCAT_DATA.TPS_RT_16;
  if afr_data.BCN then self.FWorkY_afr:=EDUCAT_DATA.BCN_RT_16;

end;
if afr_data.load_count = 32 then begin
  if afr_data.dad then self.FWorkY_afr:=EDUCAT_DATA.DAD_RT_32;
  if afr_data.TPS then self.FWorkY_afr:=EDUCAT_DATA.TPS_RT_32;
end;
//----------- RT FAZA ---------------------------------------
if faza_data.RPM_count = 16 then self.FWorkX_faza:=EDUCAT_DATA.RPM_RT_16;
if faza_data.RPM_count = 32 then self.FWorkX_faza:=EDUCAT_DATA.RPM_RT_32;
//-----
if faza_data.load_count = 16 then begin
  if faza_data.dad then self.FWorkY_faza:=EDUCAT_DATA.DAD_RT_16;
  if faza_data.TPS then self.FWorkY_faza:=EDUCAT_DATA.TPS_RT_16;
  if faza_data.BCN then self.FWorkY_faza:=EDUCAT_DATA.BCN_RT_16;

end;
if faza_data.load_count = 32 then begin
  if faza_data.dad then self.FWorkY_faza:=EDUCAT_DATA.DAD_RT_32;
  if faza_data.TPS then self.FWorkY_faza:=EDUCAT_DATA.TPS_RT_32;
end;
//------------------------------------------------------------------------
result:=RT;
end;
procedure TeducationThread.generatePcnFirm_New;
var
i,t:integer;
R:integer;
begin
 educat_data.PCN_RT_IN:=0;
 educat_data.PCN_RT_out:=0;
  for i := 0 to length(educat_data.Table_PCN_DATA) - 1 do begin
    if length(educat_data.Table_PCN_DATA[i]) > 2 then begin
   if educat_data.PCN_RT_IN = 0 then educat_data.PCN_RT_IN:=I;
   if i > educat_data.PCN_RT_out then  educat_data.PCN_RT_out:=I;
    R:=0;
      for t := 0 to length(educat_data.Table_PCN_DATA[i]) - 1 do
       R:=R+(educat_data.Table_PCN_DATA[i][t]);
       r:=round(r/length(educat_data.Table_PCN_DATA[i]));
       firmware.FFirmwareData[pcn_data.Addr+i]:=R;
       setlength(educat_data.Table_PCN_DATA[i],0);
    end;
  end;
end;
procedure TeducationThread.generateBCnFirm;
var
i,t:integer;
r:integer;
begin
for i := 0 to 255 do begin
r:=0;
//Table_BCN_data
if length(educat_data.Table_BCN_data[i]) > 0 then begin

 for t := 0 to length(educat_data.Table_BCN_data[i])-1 do begin
  r:=r+educat_data.Table_BCN_data[i,t];
 end;
  r:=round(r/length(educat_data.Table_BCN_data[i]));
  setlength(educat_data.Table_BCN_data[i],0);
  if bcn_data.Addr <> 0 then firmware.FFirmwareData[bcn_data.Addr + i]:=r;
end;
end;
end;
procedure teducationthread.generateFazaFirm;
var
i,t,r:integer;
begin
 for i := 0 to 255 do begin
 r:=0;
 if length(educat_data.Table_FAZA_DATA[i]) > 0 then  begin
   for t := 0 to length(educat_data.Table_FAZA_DATA[i]) - 1 do
   r:=r+educat_data.Table_FAZA_DATA[i][t];
   r:=r div length(educat_data.Table_FAZA_DATA[i]);
   if faza_data.Addr > 0 then firmware.FFirmwareData[faza_data.Addr + i]:=r;
   setlength(educat_data.Table_FAZA_DATA[i],0);
 end;
 end;
end;
//считываем нормальный коэфицент
function TeducationThread.ReadTableNormCoeff(X:integer;Y:integer):boolean;
begin
if length(educat_data.Table_count_norm) <> pcn_data.RPM_count + 1 then exit(false);
if length(educat_data.Table_count_norm[0])<>pcn_data.load_count + 1 then exit(false);
if educat_data.Table_count_norm[x,y] > 3 then exit(true) else exit(false);
end;
function teducationThread.ReadCnock(x: Integer; Y: Integer):boolean;
begin
 if educat_data.Table_Cnock[x,y] > 1 then  result:=true else result:=False;
end;
end.
