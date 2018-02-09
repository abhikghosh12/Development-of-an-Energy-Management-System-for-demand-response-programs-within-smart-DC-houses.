// CP: 65001
// SimulationX Version: 3.7.2.40674 x64
within ;
model HeatingUnitFlowTemperatureDCTRIAL "HeatingUnitFlowTemperatureDCTRIAL.mo"
	GreenBuilding.Interfaces.Thermal.VolumeFlowIn FlowSupply "Flow pipe of heating unit" annotation(Placement(
		transformation(extent={{-60,40},{-40,60}}),
		iconTransformation(extent={{-210,90},{-190,110}})));
	GreenBuilding.Interfaces.Thermal.VolumeFlowOut ReturnSupply "Return pipe of heating unit" annotation(Placement(
		transformation(extent={{-55,10},{-35,30}}),
		iconTransformation(extent={{-210,-110},{-190,-90}})));
	GreenBuilding.Interfaces.Thermal.VolumeFlowIn ReturnSink "Heat sink return pipe" annotation(Placement(
		transformation(extent={{185,-25},{205,-5}}),
		iconTransformation(extent={{190,-110},{210,-90}})));
	GreenBuilding.Interfaces.Thermal.VolumeFlowOut FlowSink "Heat sink flow pipe" annotation(Placement(
		transformation(extent={{320,0},{340,20}}),
		iconTransformation(extent={{190,90},{210,110}})));
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
				origin={135,-60},
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
				origin={190,-45},
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
				origin={135,90},
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
		Placement(transformation(extent={{-10,0},{10,20}})),
		Dialog(
			group="Energy",
			tab="Results"));
	GreenBuilding.Utilities.Thermal.MeasureThermal MeasFlow "Flow temperature measurement" annotation(Placement(transformation(extent={{60,55},{80,75}})));
	GreenBuilding.Utilities.Thermal.MeasureThermal MeasReturn "Return temperature measurement" annotation(Placement(transformation(extent={{-150,90},{-130,110}})));
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
	DCpump dCpump1 annotation(Placement(transformation(extent={{175,15},{195,35}})));
	GreenBuilding.Interfaces.Electrical.DC DC "DC grid connection" annotation(Placement(
		transformation(extent={{110,-20},{130,0}}),
		iconTransformation(extent={{-160,-210},{-140,-190}})));
	equation
		connect(FlowSupply,FlowTempControl.SupplyFlow) annotation(Line(points={{-50,50},{-45,50},{-15,50},{-15,15},{-10,15}}));
		connect(ReturnSupply,FlowTempControl.SupplyReturn) annotation(Line(points={{-45,20},{-40,20},{-15,20},{-15,5},{-10,5}}));
		connect(FlowTempControl.TFlowRef,TRef) annotation(Line(points={{0,20},{0,25},{0,95},{40,95},{45,95}}));
		der(ECP)=PCP;
		ECP=dCpump1.ESP;
		
		connect(ReturnSink,MeasReturn.PipeIn) annotation(
			Line(points={{195,-15},{195,-65},{-155,-65},{-155,100},{-150,100}}),
			AutoRoute=false);
		connect(MeasReturn.PipeOut,FlowTempControl.SinkReturn) annotation(Line(points={{-130,100},{-125,100},{15,100},{15,5},{10,5}}));
		connect(FlowTempControl.SinkFlow,MeasFlow.PipeIn) annotation(Line(points={{10,15},{15,15},{55,15},{55,65},{60,65}}));
		connect(MeasFlow.TMedium,TFlowSink) annotation(Line(points={{70,55},{70,50},{70,-60},{130,-60},{135,-60}}));
		connect(MeasReturn.TMedium,TReturnSink) annotation(Line(points={{-140,90},{-140,85},{-140,-45},{185,-45},{190,-45}}));
		connect(MeasFlow.PipeOut,dCpump1.ReturnHP) annotation(Line(
			points={{80,65},{85,65},{200,65},{200,20},{195,20}},
			color={190,30,45}));
		connect(dCpump1.FlowHP,FlowSink) annotation(Line(
			points={{195,30},{200,30},{325,30},{325,10},{330,10}},
			color={190,30,45}));
		connect(dCpump1.qvRef,qvRef) annotation(Line(
			points={{185,35},{185,40},{185,90},{140,90},{135,90}},
			color={0,0,127},
			thickness=0.0625));
		
		connect(dCpump1.Grid,DC) annotation(Line(
			points={{180,15},{180,10},{180,-10},{125,-10},{120,-10}},
			color={247,148,29},
			thickness=0.0625));
	annotation(
		TRef(flags=2),
		TFlowSink(flags=2),
		TReturnSink(flags=2),
		qvRef(flags=2),
		PCP(flags=2),
		ECP(flags=2),
		dCpump1(
			ESP(flags=2),
			PSP(flags=2)),
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
Content-Location: C:\\Users\\ghosh\\AppData\\Local\\Temp\\6\\itiDFE1.tmp\\hlp3014.tmp\\HeatingUnitFlowTemperatureDCTRIAL.htm

<=21DOCTYPE HTML PUBLIC =22-//W3C//DTD HTML 4.0 Transitional//EN=22>
<=21DOCTYPE html PUBLIC =22-//W3C//DTD HTML 4.0 Transitional//EN=22 =22=22><=
HTML><HEAD><TITLE>Example_C_Renewable 
 energy system model V1.0</TITLE> 
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
<P class=3D=22Ueberschrift1=22 
style=3D=22margin-top: 0px; margin-bottom: 0px;=22>Example_C_Renewable energ=
y system   
 model V1.0</P>
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
width=3D=2265=22 height=3D=2235=22 
      src=3D=22HeatingUnitFlowTemperatureDCTRIAL=5Csymbol.png=22></TD></TR>=

  <TR>
    <TD width=3D=2215%=22 valign=3D=22top=22 bgcolor=3D=22=2395c9f0=22>
      <P>Ident:</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22 colspan=3D=223=22>
      <P 
  class=3D=22SymbolTab=22>GreenBuilding.Examples.Example_C_Complex_Model</P>=
</TD></TR>
  <TR>
    <TD width=3D=2215%=22 valign=3D=22top=22 bgcolor=3D=22=2395c9f0=22>
      <P>Version:</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22 colspan=3D=223=22>
      <P class=3D=22SymbolTab=22>1.0</P></TD></TR>
  <TR>
    <TD width=3D=2215%=22 valign=3D=22top=22 bgcolor=3D=22=2395c9f0=22>
      <P>File:</P></TD>
    <TD valign=3D=22top=22 bgcolor=3D=22=23efefef=22 colspan=3D=223=22>
      <P class=3D=22SymbolTab=22></P></TD></TR></TBODY></TABLE>
<P class=3D=22Ueberschrift2=22>Description:</P>
<P style=3D=22margin-top: 6pt; margin-bottom: 0px;=22>This more complex buil=
ding     
energy  system model includes renewable production systems (photovolatic    =

 system,  micro-wind-turbine), energy storages (li-Ion battery, geat storage=
)    
and  a  heating system (heat pump) for a two-zonal building system (one heat=
ed   
 zone,  one  non-heated zone). </P>
<P style=3D=22margin-top: 6pt; margin-bottom: 0px;=22>Especially, it is show=
n how a    
 more complex building architecture can be modeled using several elements of=
 the 
  'Building'-Package of =22GreenBuilding=22-Library.</P></BODY></HTML>


----$iti$
Content-Type: image/png
Content-Transfer-Encoding: base64
Content-Location: HeatingUnitFlowTemperatureDCTRIAL\\symbol.png

iVBORw0KGgoAAAANSUhEUgAAAEEAAAAjCAYAAADLy2cUAAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAAJcEhZcwAADsMAAA7DAcdvqGQAAACFSURBVGhD7dlBDoAgEEPRuf+lRwliiBEXLodn4gGs7S/aSFcGDZIIzQScQIQOg1cnRERWvp8cXIpQFZjt5RKBCGf+iUCE3gScQAROGLUoDphwHZGBERiBERinLybtoB20wx0IcRAHcRCH+Z8iJmACJvxjwvbjS9XhZfVcBlmD7Mcgu1scDlKwjERkwRQaAAAAAElFTkSuQmCC

----$iti$--"),
		experiment(
			StopTime=1,
			StartTime=0,
			Interval=0.002,
			MaxInterval="10",
			AbsTolerance="1e-06"));
end HeatingUnitFlowTemperatureDCTRIAL;
