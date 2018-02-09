// CP: 65001
// SimulationX Version: 3.7.2.40674 x64
within ;
model DCDCconvertertotal "DCDCconverterall.mo"
	GreenBuilding.Interfaces.Electrical.DC DCinput "DC connection to PV system" annotation(Placement(
		transformation(extent={{45,-25},{65,-5}}),
		iconTransformation(extent={{190,40},{210,60}})));
	GreenBuilding.Interfaces.Electrical.DC DCoutput "DC connection to PV system" annotation(Placement(
		transformation(extent={{45,-25},{65,-5}}),
		iconTransformation(extent={{-210,40},{-190,60}})));
	input Modelica.Blocks.Interfaces.RealInput PowerConsumption(
		quantity="Basics.Power",
		displayUnit="kW") " power for consumptionof house" annotation(
		Placement(
			transformation(
				origin={60,55},
				extent={{-20,-20},{20,20}},
				rotation=-90),
			iconTransformation(
				origin={100,-200},
				extent={{-20,-20},{20,20}},
				rotation=-90)),
		Dialog(
			group="Electrical Power",
			tab="Results",
			showAs=ShowAs.Result));
	input Modelica.Blocks.Interfaces.RealInput VRef(quantity="Basics.Power") "Reference dc voltage" annotation(
		Placement(
			transformation(
				origin={60,55},
				extent={{-20,-20},{20,20}},
				rotation=-90),
			iconTransformation(
				origin={0,-200},
				extent={{-20,-20},{20,20}},
				rotation=-90)),
		Dialog(
			group="Electrical Power",
			tab="Results",
			showAs=ShowAs.Result));
	GreenBuilding.Interfaces.Electrical.DefineCurrentDC GridConnection annotation(
		Placement(transformation(
			origin={240,-70},
			extent={{10,-10},{-10,10}},
			rotation=90)),
		Dialog(
			group="Coefficient of Performance",
			tab="Results 1"));
	Real ECP(
		quantity="Basics.Energy",
		displayUnit="kWh") "Electrical energy " annotation(Dialog(
		group="Energy",
		tab="Results",
		showAs=ShowAs.Result));
	Real ECPTOTAL(
		quantity="Basics.Energy",
		displayUnit="kWh") "Electrical energy " annotation(Dialog(
		group="Energy",
		tab="Results",
		showAs=ShowAs.Result));
	Real PDCinput(
		quantity="Basics.Power",
		displayUnit="kW") "DC power" annotation(Dialog(
		group="Power",
		tab="Results",
		showAs=ShowAs.Result));
	Real PDCoutput(
		quantity="Basics.Power",
		displayUnit="kW") "DC power" annotation(Dialog(
		group="Power",
		tab="Results",
		showAs=ShowAs.Result));
	parameter Real alpha=0.97222222222222221 "duty cycle" annotation(Dialog(
		group="Power",
		tab="Results",
		showAs=ShowAs.Result));
	equation
		der(ECPTOTAL)=PowerConsumption;
			der(ECP)=PDCoutput;
				PDCinput=  (DCinput.I*DCinput.V);
				
				GridConnection.V = VRef;
								if (GridConnection.V>1e-10) then
									GridConnection.I=(PDCinput*alpha)/GridConnection.V;
									
								else
									GridConnection.I=0;
									
								end if;
								PDCoutput=abs(GridConnection.I*GridConnection.V);
				connect(DCoutput,GridConnection.FlowCurrent) annotation(Line(points={{55,-15},{60,-15},{60,-85},{240,-85},{240,-80}}));
	annotation(Icon(
		coordinateSystem(extent={{-200,-200},{200,200}}),
		graphics={
			Bitmap(
				imageSource="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",
				extent={{-200,200},{207,-203}})}));
end DCDCconvertertotal;
