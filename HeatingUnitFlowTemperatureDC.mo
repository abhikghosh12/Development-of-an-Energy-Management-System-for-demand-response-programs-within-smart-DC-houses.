// CP: 65001
// SimulationX Version: 3.7.2.40674 x64
within ;
model HeatingUnitFlowTemperatureDC "HeatingUnitFlowTemperatureDC.isx"
	GreenBuilding.Interfaces.Thermal.VolumeFlowIn FlowSupply "Flow pipe of heating unit" annotation(Placement(
		transformation(extent={{-20,55},{0,75}}),
		iconTransformation(extent={{-210,90},{-190,110}})));
	GreenBuilding.Interfaces.Thermal.VolumeFlowOut ReturnSupply "Return pipe of heating unit" annotation(Placement(
		transformation(extent={{-20,0},{0,20}}),
		iconTransformation(extent={{-210,-110},{-190,-90}})));
	GreenBuilding.Interfaces.Electrical.DC DC "DC grid connection" annotation(Placement(
		transformation(extent={{85,-40},{105,-20}}),
		iconTransformation(extent={{-160,-210},{-140,-190}})));
	GreenBuilding.Interfaces.Thermal.VolumeFlowIn ReturnSink "Heat sink return pipe" annotation(Placement(
		transformation(extent={{195,-5},{215,15}}),
		iconTransformation(extent={{190,-110},{210,-90}})));
	GreenBuilding.Interfaces.Thermal.VolumeFlowOut FlowSink "Heat sink flow pipe" annotation(Placement(
		transformation(extent={{195,55},{215,75}}),
		iconTransformation(extent={{190,90},{210,110}})));
	parameter Real eta(
		quantity="Basics.RelMagnitude",
		displayUnit="%")=0.95 "Charge efficiency " annotation(Dialog(
		group="Efficiency",
		tab="Parameters"));
	input Modelica.Blocks.Interfaces.RealInput TRef(
		quantity="Thermics.Temp",
		displayUnit="°C") "Heating unit reference temperature" annotation(
		Placement(
			transformation(
				origin={45,95},
				extent={{-20,-20},{20,20}},
				rotation=-90),
			iconTransformation(
				origin={-50,200},
				extent={{-20,-20},{20,20}},
				rotation=-90)),
		Dialog(
			group="Temperature",
			tab="Results",
			showAs=ShowAs.Result));
	output Modelica.Blocks.Interfaces.RealOutput TFlowSink(
		quantity="Thermics.Temp",
		displayUnit="°C") "Flow temperature of heat sink" annotation(
		Placement(
			transformation(
				origin={140,-30},
				extent={{-10,-10},{10,10}},
				rotation=-90),
			iconTransformation(
				origin={50,-200},
				extent={{-10,-10},{10,10}},
				rotation=-90)),
		Dialog(
			group="Temperature",
			tab="Results",
			showAs=ShowAs.Result));
	output Modelica.Blocks.Interfaces.RealOutput TReturnSink(
		quantity="Thermics.Temp",
		displayUnit="°C") "Return temperature of heat sink" annotation(
		Placement(
			transformation(
				origin={185,-30},
				extent={{-10,-10},{10,10}},
				rotation=-90),
			iconTransformation(
				origin={150,-200},
				extent={{-10,-10},{10,10}},
				rotation=-90)),
		Dialog(
			group="Temperature",
			tab="Results",
			showAs=ShowAs.Result));
	input Modelica.Blocks.Interfaces.RealInput qvRef(
		quantity="Thermics.VolumeFlow",
		displayUnit="l/min") "Reference volume flow for heating unit" annotation(
		Placement(
			transformation(
				origin={90,95},
				extent={{-20,-20},{20,20}},
				rotation=-90),
			iconTransformation(
				origin={100,200},
				extent={{-20,20},{20,-20}},
				rotation=270)),
		Dialog(
			group="Volume Flow",
			tab="Results",
			showAs=ShowAs.Result));
	Real PCP(
		quantity="Basics.Power",
		displayUnit="kW") "Electrical power of circulation pump" annotation(Dialog(
		group="Electrical Power",
		tab="Results",
		showAs=ShowAs.Result));
	Real ECP(
		quantity="Basics.Energy",
		displayUnit="kWh") "Electrical energy of circulation pump" annotation(Dialog(
		group="Energy",
		tab="Results",
		showAs=ShowAs.Result));
	GreenBuilding.Utilities.Thermal.HydraulicValveFlow FlowTempControl(
		cpMed(displayUnit="J/(kg·K)")=cpMed,
		rhoMed=rhoMed,
		TAmbient(displayUnit="K")=TAmbient,
		VValve(displayUnit="m³")=VValve,
		QlossRate=QlossRate) "Flow temperature control" annotation(
		Placement(transformation(extent={{-10,-10},{10,10}})),
		Dialog(
			group="Energy",
			tab="Results"));
	GreenBuilding.Utilities.Thermal.Pump CirculationPump(
		PelFile=filePowerPump,
		PelTable=tablePowerPump,
		usePowerCalc=1,
		CPPhase=1,
		CosPhi=1,
		qvMax(displayUnit="m³/s")=qvMaxPump) "Hot water supply pump" annotation(
		Placement(transformation(extent={{-10,-10},{10,10}})),
		Dialog(
			group="Energy",
			tab="Results"));
	GreenBuilding.Utilities.Electrical.B2Converter B2Converter(eta=eta) "B2-Converter for 1-phase-grid-connection" annotation(
		Placement(transformation(extent={{-10,-10},{10,10}})),
		Dialog(
			group="State of Charge",
			tab="Parameters"));
	GreenBuilding.Utilities.Thermal.MeasureThermal MeasFlow "Flow temperature measurement" annotation(Placement(transformation(extent={{-150,90},{-130,110}})));
	GreenBuilding.Utilities.Thermal.MeasureThermal MeasReturn "Return temperature measurement" annotation(Placement(transformation(extent={{-150,90},{-130,110}})));
	parameter String filePowerPump=GreenBuilding.Utilities.Functions.getModelDataDirectory()+"\\circulation_pump\\CPDC_25_60.txt" "File name where electrical power data of circulation pump is located" annotation(Dialog(
		group="Circulation Pump - Power Data",
		tab="Parameters 1"));
	parameter String tablePowerPump="P_CP" "Table name where electrical power data of circulation pump is located" annotation(Dialog(
		group="Circulation Pump - Power Data",
		tab="Parameters 1"));
	parameter Real qvMaxPump(
		quantity="Thermics.VolumeFlow",
		displayUnit="m³/h")=0.00083333333333333328 "Maximum volume flow of pump" annotation(Dialog(
		group="Circulation Pump - Dimensions",
		tab="Parameters 1"));
	parameter Real cpMed(
		quantity="Thermics.SpecHeatCapacity",
		displayUnit="kJ/(kg·K)")=4177 "Specific heat capacity of heating medium" annotation(Dialog(
		group="Water Properties",
		tab="Parameters 2"));
	parameter Real rhoMed(
		quantity="Basics.Density",
		displayUnit="kg/m³")=1000 "Density of heating medium" annotation(Dialog(
		group="Water Properties",
		tab="Parameters 2"));
	parameter Real VValve(
		quantity="Geometry.Volume",
		displayUnit="l")=0.001 "Volume of hydraulic valve" annotation(Dialog(
		group="Valve Dimensions",
		tab="Parameters 2"));
	parameter Real QlossRate(
		quantity="Thermics.HeatCond",
		displayUnit="W/K")=0.2 "Heat loss rate of isolation" annotation(Dialog(
		group="Valve Dimensions",
		tab="Parameters 2"));
	parameter Real TAmbient(
		quantity="Thermics.Temp",
		displayUnit="°C")=291.14999999999998 "Ambient temperature of hydraulic valve" annotation(Dialog(
		group="Ambience",
		tab="Parameters 2"));
	equation
			connect(FlowSupply,FlowTempControl.SupplyFlow) annotation(Line(points={{-10,65},{-15,65},{-15,5},{-10,5}}));
			connect(ReturnSupply,FlowTempControl.SupplyReturn) annotation(Line(points={{-10,10},{-15,10},{-15,-5},{-10,-5}}));
			connect(FlowTempControl.TFlowRef,TRef) annotation(Line(points={{0,10},{0,15},{0,95},{40,95},{45,95}}));
			connect(CirculationPump.qvRef,qvRef) annotation(Line(points={{0,-10},{0,-15},{42.3,-15},{42.3,95},{85,95},{90,
			95}}));
			connect(CirculationPump.PumpOut,FlowSink) annotation(Line(points={{-10,0},{-15,0},{-15,65},{200,65},{205,65}}));
			B2Converter.Connected=true;
			B2Converter.alphaRef=1;	
			
			connect(CirculationPump.Grid1,B2Converter.Grid1) annotation(Line(points={{-5,10},{-5,15},{-15,15},{-15,0},{-10,0}}));
			connect(B2Converter.DC,DC) annotation(Line(points={{10,0},{15,0},{90,0},{90,-30},{95,-30}}));
		
		
				PCP=CirculationPump.PCP;
				ECP=CirculationPump.ECP;
			
			connect(ReturnSink,MeasReturn.PipeIn) annotation(Line(points={{205,5},{200,5},{-155,5},{-155,100},{-150,100}}));
			connect(MeasReturn.PipeOut,FlowTempControl.SinkReturn) annotation(Line(points={{-130,100},{-125,100},{15,100},{15,-5},{10,-5}}));
			connect(FlowTempControl.SinkFlow,MeasFlow.PipeIn) annotation(Line(points={{10,5},{15,5},{15,52.3},{-155,52.3},{-155,100},{-150,
			100}}));
			connect(MeasFlow.PipeOut,CirculationPump.PumpIn) annotation(Line(points={{-130,100},{-125,100},{15,100},{15,0},{10,0}}));
			connect(MeasFlow.TMedium,TFlowSink) annotation(Line(points={{-140,90},{-140,85},{-140,-30},{135,-30},{140,-30}}));
			connect(MeasReturn.TMedium,TReturnSink) annotation(Line(points={{-140,90},{-140,85},{-140,-30},{180,-30},{185,-30}}));
	annotation(
		viewinfo[0](
			simViewInfos[0](
				runtimeClass="CSimView",
				tabGroup=0,
				tabFrame=0,
				tabAlignment=0,
				typename="ModelViewInfo"),
			simViewInfos[1](
				runtimeClass="CSimXModelicaView",
				tabGroup=0,
				tabFrame=0,
				tabAlignment=0,
				typename="ViewInfo"),
			simViewInfos[2](
				runtimeClass="CSimXModelicaView",
				tabGroup=0,
				tabFrame=0,
				tabAlignment=0,
				typename="ViewInfo"),
			typename="ModelInfo"),
		Icon(
			coordinateSystem(extent={{-200,-200},{200,200}}),
			graphics={
				Bitmap(
					imageSource="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
IwAAAABJRU5ErkJggg==",
					extent={{-203,200},{217,-200}})}),
		Documentation(info="MIME-Version: 1.0
Content-Type: multipart/related;boundary=\"--$iti$\";type=\"text/html\"

----$iti$
Content-Type:text/html;charset=\"iso-8859-1\"
Content-Transfer-Encoding: quoted-printable
Content-Location: C:\\Users\\ghosh\\AppData\\Local\\Temp\\6\\itiDFE1.tmp\\hlpD37E.tmp\\HeatingUnitFlowTemperatureDC.htm

<=21DOCTYPE HTML PUBLIC =22-//W3C//DTD HTML 4.0 Transitional//EN=22>
<=21DOCTYPE html PUBLIC =22-//W3C//DTD HTML 4.0 Transitional//EN=22 =22=22><=
HTML><HEAD><TITLE>Flow 
temperature controller wiring for heating system V1.0</TITLE> 
<META http-equiv=3D=22Content-Type=22 content=3D=22text/html; charset=3Diso-=
8859-1=22> 
<STYLE type=3D=22text/css=22>
p, li =7Bfont-family: Verdana, Arial, Helvetic=
a, sans-serif; font-size:12px; color: =23000000;=7D
.Ueberschrift1 =7Bfont-f=
amily: Verdana, Arial, Helvetica, sans-serif; font-size:14px; font-weight:bo=
ld; color:=23000000; margin-top:0; margin-bottom:6px;=7D
.Ueberschrift2 =7Bf=
ont-family: Verdana, Arial, Helvetica, sans-serif; font-size:12px; font-weig=
ht:bold; color:=23000000; margin-top:6px; margin-bottom:6px;=7D
.Ueberschrif=
t3 =7Bfont-family: Verdana, Arial, Helvetica, sans-serif; font-size:12px; fo=
nt-weight:bold; font-style:italic; color:=23000000; margin-top:6px; margin-b=
ottom:6px;=7D
.SymbolTab =7Bfont-family: Verdana, Arial, Helvetica, sans-ser=
if; font-size:12px; font-weight:bold; color:=23000000;=7D
</STYLE>
 <LINK href=3D=22../format_help.css=22 rel=3D=22stylesheet=22> 
<META name=3D=22GENERATOR=22 content=3D=22MSHTML 11.00.9600.18525=22></HEAD>=
 
<BODY bgcolor=3D=22=23ffffff=22 link=3D=22=230000ff=22 vlink=3D=22=23800080=
=22>
<P class=3D=22Ueberschrift1=22 style=3D=22margin-top: 0px; margin-bottom: 0p=
x;=22>Flow 
 temperature controller wiring for heating system V1.0</P>
<HR size=3D=221=22 style=3D=22margin-top: 0px; margin-bottom: 0px;=22 noshad=
e=3D=22=22>

<TABLE width=3D=22100%=22 bordercolor=3D=22=23ffffff=22 bordercolorlight=3D=
=22=23ffffff=22 
bordercolordark=3D=22=23ffffff=22 bgcolor=3D=22=23cccccc=22 border=3D=221=22=
 cellspacing=3D=220=22 
cellpadding=3D=222=22>
  <TBODY>
  <TR>
    <TD width=3D=2215%=22 valign=3D=22top=22 bgcolor=3D=22=2395c9f0=22>
      <P>Symbol:</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23ffffff=22 colspan=3D=223=22><IMG =
width=3D=22124=22 height=3D=22124=22 
      src=3D=22HeatingUnitFlowTemperatureDC=5Csymbol.png=22></TD></TR>
  <TR>
    <TD width=3D=2215%=22 valign=3D=22top=22 bgcolor=3D=22=2395c9f0=22>
      <P>Ident:</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22 colspan=3D=223=22>
      <P 
      class=3D=22SymbolTab=22>GreenBuilding.HeatingSystem.HeatingUnitFlowTem=
perature</P></TD></TR>
  <TR>
    <TD width=3D=2215%=22 valign=3D=22top=22 bgcolor=3D=22=2395c9f0=22>
      <P>Version:</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22 colspan=3D=223=22>
      <P class=3D=22SymbolTab=22>1.0</P></TD></TR>
  <TR>
    <TD width=3D=2215%=22 valign=3D=22top=22 bgcolor=3D=22=2395c9f0=22>
      <P>File:</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22 colspan=3D=223=22>
      <P class=3D=22SymbolTab=22></P></TD></TR>
  <TR>
    <TD width=3D=2215%=22 valign=3D=22top=22 bgcolor=3D=22=2395c9f0=22>
      <P>Connectors:</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>Flow pipe of heating unit</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>FlowSupply</P></TD>
    <TD width=3D=2235%=22 valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P>&nbsp;</P></TD></TR>
  <TR>
    <TD width=3D=2215%=22 valign=3D=22top=22 bgcolor=3D=22=2395c9f0=22>
      <P>&nbsp;</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>Return pipe of heating unit</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>ReturnSupply</P></TD>
    <TD width=3D=2235%=22 valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P>&nbsp;</P></TD></TR>
  <TR>
    <TD width=3D=2215%=22 valign=3D=22top=22 bgcolor=3D=22=2395c9f0=22>
      <P>&nbsp;</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>Single phase grid connection</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>Grid1</P></TD>
    <TD width=3D=2235%=22 valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P>&nbsp;</P></TD></TR>
  <TR>
    <TD width=3D=2215%=22 valign=3D=22top=22 bgcolor=3D=22=2395c9f0=22>
      <P>&nbsp;</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>Heat sink return pipe</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>ReturnSink</P></TD>
    <TD width=3D=2235%=22 valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P>&nbsp;</P></TD></TR>
  <TR>
    <TD width=3D=2215%=22 valign=3D=22top=22 bgcolor=3D=22=2395c9f0=22>
      <P>&nbsp;</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>Heat sink flow pipe</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>FlowSink</P></TD>
    <TD width=3D=2235%=22 valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P>&nbsp;</P></TD></TR>
  <TR>
    <TD width=3D=2215%=22 valign=3D=22top=22 bgcolor=3D=22=2395c9f0=22>
      <P>&nbsp;</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>Heating unit reference temperature</P></TD>=

    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>TRef</P></TD>
    <TD width=3D=2235%=22 valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P>&nbsp;</P></TD></TR>
  <TR>
    <TD width=3D=2215%=22 valign=3D=22top=22 bgcolor=3D=22=2395c9f0=22>
      <P>&nbsp;</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>Flow temperature of heat sink</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>TFlowSink</P></TD>
    <TD width=3D=2235%=22 valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P>&nbsp;</P></TD></TR>
  <TR>
    <TD width=3D=2215%=22 valign=3D=22top=22 bgcolor=3D=22=2395c9f0=22>
      <P>&nbsp;</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>Return temperature of heat sink</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>TReturnSink</P></TD>
    <TD width=3D=2235%=22 valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P>&nbsp;</P></TD></TR>
  <TR>
    <TD width=3D=2215%=22 valign=3D=22top=22 bgcolor=3D=22=2395c9f0=22>
      <P>&nbsp;</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>Reference volume flow for heating unit</P><=
/TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>qvRef</P></TD>
    <TD width=3D=2235%=22 valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P>&nbsp;</P></TD></TR>
  <TR>
    <TD width=3D=2215%=22 valign=3D=22top=22 bgcolor=3D=22=2395c9f0=22>
      <P>Parameters:</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>File name where electrical power data of ci=
rculation  
           pump is located</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>filePowerPump</P></TD>
    <TD width=3D=2235%=22 valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P>&nbsp;</P></TD></TR>
  <TR>
    <TD width=3D=2215%=22 valign=3D=22top=22 bgcolor=3D=22=2395c9f0=22>
      <P>&nbsp;</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>Table name where electrical power data of c=
irculation 
            pump is located</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>tablePowerPump</P></TD>
    <TD width=3D=2235%=22 valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P>&nbsp;</P></TD></TR>
  <TR>
    <TD width=3D=2215%=22 valign=3D=22top=22 bgcolor=3D=22=2395c9f0=22>
      <P>&nbsp;</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>If enabled, electrical power calculation fo=
r       
      circulation pump is used</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>usePowerCalcPump</P></TD>
    <TD width=3D=2235%=22 valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P>&nbsp;</P></TD></TR>
  <TR>
    <TD width=3D=2215%=22 valign=3D=22top=22 bgcolor=3D=22=2395c9f0=22>
      <P>&nbsp;</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>Number of phases circulation pump is connec=
ted 
     to</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>CPPhasePump</P></TD>
    <TD width=3D=2235%=22 valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P>&nbsp;</P></TD></TR>
  <TR>
    <TD width=3D=2215%=22 valign=3D=22top=22 bgcolor=3D=22=2395c9f0=22>
      <P>&nbsp;</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>Power factor of pump</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>CosPhiPump</P></TD>
    <TD width=3D=2235%=22 valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P>&nbsp;</P></TD></TR>
  <TR>
    <TD width=3D=2215%=22 valign=3D=22top=22 bgcolor=3D=22=2395c9f0=22>
      <P>&nbsp;</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>Maximum volume flow of pump</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>qvMaxPump</P></TD>
    <TD width=3D=2235%=22 valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P>&nbsp;</P></TD></TR>
  <TR>
    <TD width=3D=2215%=22 valign=3D=22top=22 bgcolor=3D=22=2395c9f0=22>
      <P>&nbsp;</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>Specific heat capacity of heating medium</P=
></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>cpMed</P></TD>
    <TD width=3D=2235%=22 valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P>&nbsp;</P></TD></TR>
  <TR>
    <TD width=3D=2215%=22 valign=3D=22top=22 bgcolor=3D=22=2395c9f0=22>
      <P>&nbsp;</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>Density of heating medium</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>rhoMed</P></TD>
    <TD width=3D=2235%=22 valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P>&nbsp;</P></TD></TR>
  <TR>
    <TD width=3D=2215%=22 valign=3D=22top=22 bgcolor=3D=22=2395c9f0=22>
      <P>&nbsp;</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>Volume of hydraulic valve</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>VValve</P></TD>
    <TD width=3D=2235%=22 valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P>&nbsp;</P></TD></TR>
  <TR>
    <TD width=3D=2215%=22 valign=3D=22top=22 bgcolor=3D=22=2395c9f0=22>
      <P>&nbsp;</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>Heat loss rate of isolation</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>QlossRate</P></TD>
    <TD width=3D=2235%=22 valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P>&nbsp;</P></TD></TR>
  <TR>
    <TD width=3D=2215%=22 valign=3D=22top=22 bgcolor=3D=22=2395c9f0=22>
      <P>&nbsp;</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>Ambient temperature of hydraulic valve</P><=
/TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>TAmbient</P></TD>
    <TD width=3D=2235%=22 valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P>&nbsp;</P></TD></TR>
  <TR>
    <TD width=3D=2215%=22 valign=3D=22top=22 bgcolor=3D=22=2395c9f0=22>
      <P>Results:</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>Flow temperature of heat sink</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>TFlowSink</P></TD>
    <TD width=3D=2235%=22 valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P>&nbsp;</P></TD></TR>
  <TR>
    <TD width=3D=2215%=22 valign=3D=22top=22 bgcolor=3D=22=2395c9f0=22>
      <P>&nbsp;</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>Return temperature of heat sink</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>TReturnSink</P></TD>
    <TD width=3D=2235%=22 valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P>&nbsp;</P></TD></TR>
  <TR>
    <TD width=3D=2215%=22 valign=3D=22top=22 bgcolor=3D=22=2395c9f0=22>
      <P>&nbsp;</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>Electrical power of circulation pump</P></T=
D>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>PCP</P></TD>
    <TD width=3D=2235%=22 valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P>&nbsp;</P></TD></TR>
  <TR>
    <TD width=3D=2215%=22 valign=3D=22top=22 bgcolor=3D=22=2395c9f0=22>
      <P>&nbsp;</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>Electrical energy of circulation pump</P></=
TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P class=3D=22SymbolTab=22>ECP</P></TD>
    <TD width=3D=2235%=22 valign=3D=22top=22 bgcolor=3D=22=23efefef=22>
      <P>&nbsp;</P></TD></TR></TBODY></TABLE>
<P class=3D=22Ueberschrift2=22>Description:</P>
<P style=3D=22margin-top: 6pt; margin-bottom: 0px;=22>This auxiliary&nbsp;mo=
del 
 controls the flow temperature to the heat sink via an internal circulation =
pump 
 as well as the heat supply&nbsp;flow temperature&nbsp;and the&nbsp;heat sin=
k 
 return temperature. It could be used to define flow temperature and overall=
 
 volume flow for several heating systems connected in series or parallel.</P=
>
<P style=3D=22margin-top: 6pt; margin-bottom: 0px;=22>The internal circulati=
on pump 
can  be regarded as an electrical circulation pump. That way, the electrical=
 
power  supply has to be provided via an external grid connection (single or =

three  phase).</P></BODY></HTML>


----$iti$
Content-Type: image/png
Content-Transfer-Encoding: base64
Content-Location: HeatingUnitFlowTemperatureDC\\symbol.png

iVBORw0KGgoAAAANSUhEUgAAAHwAAAB8CAYAAACrHtS+AAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAAJcEhZcwAADsMAAA7DAcdvqGQAABAQSURBVHhe7Z0JcBRFF8dRP+GrgqLkVDnMQRKOhFNADjnlJgJyCKiAEA/AgHyigBZyKaKIIHLK8QEWKAqEWyQIyQZi7puQkHAEkBwkkBty/79+w7dbu8nOZiaZJNump6qrUpuemdfv16/79es3M3UgjlqlgTq1qrWisRDAa1knEMAF8FqmgVrW3HItvCDtPpI9TiB67kcIHTdVFA50cPnd+UjcfxD5KffKdGeLwAl2wvdbEThgJHR2HXGhmb0oHOhAZ+MM/75DcW3VN2WgWwSecuwUgoaOFZA5gGzOGP37DJUs3fiwCPzqkhXQ2XcSwDkFTpZ++R135cBpLjDXc7xbtkXAy8MROf19RM/5D2I/Xoqri5aJUq06+BxXmF8VNWM2AgeOhu4FZ7OsQl+dXDngPsziI6bMxN2ffkFObBzy76WipKiolvm6VtDckhIUpKUhN+4akg4eQdTbc3Cx7YtloFcKuHer9gh77U1kRURZQYuFCMYayLlyFVEz55ax9EoB9+s5CHd27hOatlINJP16BIGDRptYeaWAh46dipwrsVbaXCEWDe9k5cZ+V6WAR771LopycoRmrVQDFDe54v6xdsCjZs4BmLMgDivVQHExri5eriXwuVbaUr7E2rp1Kzp06GC2pKamVqoxcZ+uqFngeUkpSDzwG3JirlaqIVV98sObCUg5egrZ0TFVdquVK1di4MCBsLW1RZ06dcyWPn36SHVCQ0MrJEeNA6e1egSb+8MnTsONtd/j0Z2/rWrdXnD/AVt57EUkC2BETJ2FtHMXKqRoSyctXLgQkyZNQuvWrWVBl+4AAwYMkM45c+aMKnlqHDhZTNDwcfB61gG+HXvj8rvzmMUfQt7dxJoDz/yQwqxsBtcLsR99Cv9er8C7ZTsWPRyGe6f/UKXg8iovWbIETZo0MQE9cuRIbNmyxWxp2LChSd1+/frh5MmT5d3G8H+rAW68VAgcMAokWJrnBRYtuq+4MVpULMrJRYZfEK5/tQ5h496Ad4u2hjlPS+C5ubmgIbxBgwYGgBMnTsSKFWyOvSA/inz77bdSHTs7O8N5ZO2nTp1S1HyrBE7wyaJI4bd+2I7MoFAUZmYqalBFKxXlPpTm57/37EcU2wPwbt2hTBhSS+BpLOz55JNPGqCNHTsWwcHBisXfuHEjHBwcDOeTpSsZ3q0WuN7iLzp1Y5sw77FtvF+l2HxxXp5ipSipWJxfgIcJt0BbvTHzF+GS80uyu39aAc/KysLu3bvxxBNPSMCGDRuGqCj14egNGzaYQJ8wYUK5TbZ64HrwBOLKvE9w/4IOeYlJlZ7faUMn/14a0v0CcG3FGvj1GFTuNq8WwDMyMrBv3z6TeTgyMrJcUHIV3N3dDdfq378/wsLCLF6r5oFfvoKAIWPKVTaB93reCRSvv756HbKjolGYwYb5CgR6irJzkHM1Hre37ETwsHHS9KEkW8evzxCknFTnFZfWvk6nM4Hdtm1bxMXFmYWUyaax6OhoxMfHy0JcvXo1mjdvbgLdEnFNgQe/4YZ79+6pKje8fXCu50BFCtdDIfDkOd/ZsVdK0SnOy1cEvqSggPkCWUj+7ShCRr8uu0csB/9c596I3rtfVftK6+P48eMmwJOTk2X5HD58WKrr6Ohocs/CwkKTc1atWmW4Zq9evSzKF/HhYu0CLysaPqt4HalfV7b5V11sbdRSFXBjICGjJyLl+OnH1m7hKGFKSvf1R8SbbtDZuFTofnsat0a/evVVt1EuiEK/KwFe+vzSU4AxcEv3ov/Na9CUb+Bk7ZR0EeXmjgz/IJATZnzQXP3wRgJiF34GH4eubPhmy6zmbWoceKNGjSTYxSy+LXfoLbw0xMaNG6NZs2Y4evSodCot8dauXauoI3IPXG/tOlsXUFJeHMuzywwJlxTx8OYt3Ph6g7QH7NOmc4UgG48mWlo4BVsswSb55YDrO0CrVq2kePumTZuwbdu22gVccupYtI7SeGh+pny78EnTccmlF7yec6w0bLq+tQHXg7exsYGTk1PtA05Q/F4azCzaFX916y8lUtLfSjxwJXWsFXh587bx//8xQ/rFdt2lbI6EjdsQNesD9mBEJ4SMmoTb23YjZsFiXOrYq9LgBfBSaco14aV7t2Ih2AlvIWHDFikEm/TLYQSPnCDB9es5GLc275AidLTjRSm70lxuBU6bFnO43nIplj569Oh/9pDu9bwjgoeOk3Le75/Xsd2tLGlrNWbBEni/8DgOTh55KIvH58ZfBy3LMoPDcG3l16DcO/LslQzjVeW01a9fH5s3b5Y8bLVeuh40hWTnzp2L5cuXY8qUKdUPfFeHF6U9WjVl9ihXHGyj/Lk0rxZO8O3yspRnnXKMrb/TM8DcXQa0CHf3HpDmbWNIFJK9sWY9SgoeByuKHz6SOgh1DP/eQ8xuksh1hCO2zlg8aKiq9pXWBSUvGM+pFVmHE2i6rq+vr9Qm43U4Ldcs6X9jF9OprVJJjDSHqj30++HlWRt52jRPk3Xe/G4T8lPTTG5Fa+3Iae+BOoTxteg86gSUl218FKan4+6+nxHBooO+nftKYdvyZNAill46tOrh4YEcmcRP42XZ008/DRq6qcNcv37d0BQKy86cObNmQqtVApzNt/RkKkGLX/ql9CRF6aM4P1+aw8kzNwfNx74zYj/5XLLu0rH3R3fusi3YHxH0yhj4OHaVlnZy4LUATlugxtuaZO1ymyeenp6GvDZKbTK3bjfePKHkiOnTp1u0OU1j6VoDpzlY2iVjz0hl+AfKNiQ7MloCZslCCXq6XyAb2k0jcfqL5rLNlPhlqyVrpydozF1LC+B0v5iYGJNhnay+QEYuS/Roc8XNzc1wLe63R8OnzGLboT4ofmR5Dzzmw0UsbNrFInAasumFBdKcL3NQZ8hmu3dXPjDN3dbDryrgZOXnz59XOxti8uTJJh2HW+CBg12lhAcaboup51vYAn3g85e0ZapkqeXF0pVSjpwAbY/KQmfOH6VVUXpViOsk5hNon+JUxOL7sbGxJhkvzzzzjCE2roT8+PHjUa9ePQPwGTNmgCy+vMNqhnR9EuMtFjjJZo8rURJhSZH8xoK+YZRJ6i3zKKy5YZmGfoqxWzxYB6P5/tHtv6WnYOlxW62TGAk67XU3bdrUAM04Ni4nHyU5UPyclnV6b3/OnDlITEwsj7X0/xoHTvno5F1fZetpCpwofbyY9sDpMdhL7Xsosm49fArUkIOXn1z2/SbmNFbwIB1ZkZelpAvyUVLPqh96LZGgpZW9vb3J0EyxcfLGzZW6deua1J0/fz5u3rypCLZVACdLpoAIBUcUH8UlDFgKgoePV7ScKm3pAf1G4IHu0uPECYUHWXtmaIR0X62Ps2fPwsXFRVHgxHgNv2DBAovZMObkrHELr4jyKIP1zo97HnvTFQiT0rwct/QLtk+u3DIqIqeac44dO2bIQ3d1dZWFv2bNGkM9S6lPcvfmDjhlrWYEBCGg/4hyAyWWlmnk6CUfOsYcuGw1XKqlrre3t5R7bq5kV1Je7oDn3U2SskzLi4op+T+9f4bm59p0cAWcHhZI8zz/eBmmwZuTfDv3kd5YUV4+3D+pQ/ADnDlqFA+nhwW0gK2/RgQL7jzw8UWJhdwyAfz/Gij92q6KhFaVKpO8eXqs+GLb7poCp/1xWnJV9zNsStutdT0+LJwFQjICQ9h6/X1NYeutPGTURNyjBwxqgZVzAZyWYQnrN1cJbD10cuAKSm25am1d1nA9boBnhUci9XdP2TKney+8XLe+bBnZ9DmknD4rez7ltAvgsPxFhOqaw8mhoqgYeelyZfjAQfg3expTrrRo0hQFbNNE7nzakasNb4zkwsKVDIWDBw+2GJpUkjSo5D681xHAeSeoUn4BXKXCeK8ugPNOUKX8ArhKhfFeXQDnnaBK+QVwlQrjvboAzjtBlfIL4CoVxnt1AZx3girlF8BVKoz36gI47wRVyi+Aq1QY79UFcN4JqpRfAFe
pMN6rC+C8E1QpvwCuUmG8VxfAeSeoUn4BXKXCeK8ugPNOUKX8ArhKhfFeXQDnnaBK+QVwlQrjvboAzjtBlfIL4CoVxnt1AZx3girlF8BVKoz36gI47wRVyi+Aq1QY79UFcN4JqpRfAFepMN6rC+C8E1QpvwCuUmG8VxfAeSeoUn4BXKXCeK+uKfD1rRwN3+igd3pXZzF+f7i5L/U99dRT1SpPdbZdzb2Wv2D6MZ9KfdWoIh+qU/MZRVG3jupXbJfWWY1/ilJArDxENToUwNkHZtQojPe6ArgAbuKH1rHklZZ+MZ+Yw61/tBAWLiy84ha+pY2L7Nd45L7SI343//WiqtLL123Z57SNPi5QqWVZVb4vnfeAh7XIr2ngRQC3Fqzycgjg1s9IUwkFcE3Vaf0XE8Ctn5GmEgrgmqrT+i8mgFs/I1kJb6adQ9CtTQhM2GAoIbe3IjbFA7ce6PCwIA3sO8km5wvgHAMPvbMDB0NGYY9/T0PZF9BX+s0j/HWci1nAOsRGJGay77kUPf5mugDOMfCY5MM4GDwSm3U2Zcom9tsX5+wx73QfHAp/B5cTDyAnL0kA55g3UrIicSpqJr67YCvBXeVpj3Xsb+oAm7xtsOKsPbrt7oJFvzvgp8AhDPp+hC90F5E2XqHnF2bDJ34Z1nm1w0enHDHjSDupLDjpiC9ZByDwvfd0kn775rwdjoRNwJ+zBwvgvAInuclq9wcNkiz89d86oP2PXeGwrRteO+iMJWcc4PqzM9443B5f/WmHbRed4DHDUUPgb89GSWEhz/rjTvbUnGj8Hj2fWXQbuJ9wwthfnOG8oyvabe8GJ1b67u2ED9jvNNRv8bLB4Wl22gEPn/w28pKSuVMazwIXFufhbPx2TPPoiV5s+H6VWfRyNnevZhbd87+d0HhjD6kjbPCyxfYTNvCYqCHw0DFTkB0VzbP+uJT9boa/5LyZ89YH7OuEqYfaYw3rADsP2OK4q4bA/+o+ALe27uJSaTwLTWvs8Du7sP1iuzLQl59tIwGnOX7/MlucedFeuyHdq4UT6NPMmcFhPOuPO9lLWDwtLScWF+IWlwG+kS3PFjIP/odddjgxwg7nW1QQeGF6OiKnv1fmE886G2eEjJ6E28zSaXinOV04clXfh4rYXJ6UGQLPmA8fQ2egtx+3wa6fbLFnkT2OD7bHnzamsCnzRXHGS3FeHqJmzTX7TW+ydL8eAxE6dioipswCJUZcdnMXpYp1EDbTDbopQ3BsjJ1UTgy3w8lBdvijkz3OtywLWxVwKS679Av4OHSp0g+5G+dfib/NQ6uoXnS2LoievcBk+LGYppx65pw0Z1f0huI8bQGq1WdAvxFIPnxMOfCCB+m4s3MvgkdOEJZulAmqVvHVXV9n1xFBQ8YgYf1mFKSlKQdONQl66hlPxH22UszRVTxHa+UHXV20DMkeJ1CQagqbeFoc0qve9xR3qG4NCODVrfEavp8AXsMAqvv2Anh1a7yG7yeA1zCA6r79/wAg2m1IN1TlpgAAAABJRU5ErkJggg==

----$iti$--"),
		experiment(
			StopTime=1,
			StartTime=0,
			Interval=0.002,
			MaxInterval="10",
			AbsTolerance="1e-06"));
end HeatingUnitFlowTemperatureDC;
