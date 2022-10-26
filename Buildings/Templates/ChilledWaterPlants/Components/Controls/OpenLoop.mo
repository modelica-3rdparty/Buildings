within Buildings.Templates.ChilledWaterPlants.Components.Controls;
block OpenLoop "Open loop controller (output signals only)"
  extends
    Buildings.Templates.ChilledWaterPlants.Components.Interfaces.PartialController(
     final typ=Buildings.Templates.ChilledWaterPlants.Types.Controller.OpenLoop);

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TChiWatSupSet(
    k=Buildings.Templates.Data.Defaults.TChiWatSup)
    "CHW supply temperature set point"
    annotation (Placement(transformation(extent={{-100,250},{-80,270}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant yPumChiWatPri(
    k=1)
    if have_varPumChiWatPri and have_varComPumChiWatPri
    "Primary CHW pump speed signal"
    annotation (Placement(transformation(extent={{-130,50},{-110,70}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant yPumChiWatPriDed[nPumChiWatPri](
    each k=1)
    if have_varPumChiWatPri and not have_varComPumChiWatPri
    "Primary CHW pump speed signal - Dedicated"
    annotation (Placement(transformation(extent={{-100,30},{-80,50}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant yPumChiWatSec(
    k=1) if have_pumChiWatSec
    "Secondary CHW pump speed signal"
    annotation (Placement(transformation(extent={{-130,-10},{-110,10}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant yPumConWat(
    k=1) if typChi==Buildings.Templates.Components.Types.Chiller.WaterCooled
    and have_varPumConWat and have_varComPumConWat
    "CW pump speed signal"
    annotation (Placement(transformation(extent={{-130,-70},{-110,-50}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant yPumConWatDed[nPumConWat](
    each k=1)
    if typChi == Buildings.Templates.Components.Types.Chiller.WaterCooled
    and have_varPumConWat and not have_varComPumConWat
    "CW pump speed signal - Dedicated"
    annotation (Placement(transformation(extent={{-100,-90},{-80,-70}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant yValChiWatChiIso[nChi](
    each k=1) if typValChiWatChiIso == Buildings.Templates.Components.Types.Valve.TwoWayModulating
    "Chiller CHW isolation valve opening signal"
    annotation (Placement(transformation(extent={{-130,210},{-110,230}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant yValConWatChiIso[nChi](
    each k=1) if typValConWatChiIso == Buildings.Templates.Components.Types.Valve.TwoWayModulating
    "Chiller CW isolation valve opening signal"
    annotation (Placement(transformation(extent={{-60,170},{-40,190}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.TimeTable y1ValCooInlIso[nCoo](
    each table=[0,0; 1,0; 1,1; 2,1],
    each timeScale=1000,
    each period=2000) if typValCooInlIso == Buildings.Templates.Components.Types.Valve.TwoWayTwoPosition
    "Cooler inlet isolation valve opening signal"
    annotation (Placement(transformation(extent={{-160,-190},{-140,-170}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant yValCooInlIso[nCoo](
    each k=1) if typValCooInlIso== Buildings.Templates.Components.Types.Valve.TwoWayModulating
    "Cooler inlet isolation valve opening signal"
    annotation (Placement(transformation(extent={{-130,-210},{-110,-190}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant yValCooOutIso[nCoo](
    each k=1) if typValCooOutIso== Buildings.Templates.Components.Types.Valve.TwoWayModulating
    "Cooler outlet isolation valve opening signal"
    annotation (Placement(transformation(extent={{-50,-250},{-30,-230}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant yCoo(
    k=1)
    if typChi == Buildings.Templates.Components.Types.Chiller.WaterCooled
    "Cooler fan speed signal"
    annotation (Placement(transformation(extent={{40,-290},{60,-270}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.TimeTable y1Chi[nChi](
    each table=[0,0; 1,0; 1,1; 2,1],
    each timeScale=1000,
    each period=2000) "Chiller Start/Stop signal"
    annotation (Placement(transformation(extent={{-160,270},{-140,290}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.TimeTable y1Coo[nCoo](
    each table=[0,0; 1,0; 1,1; 2,1],
    each timeScale=1000,
    each period=2000)
    if typChi==Buildings.Templates.Components.Types.Chiller.WaterCooled
    "Cooler Start/Stop signal"
    annotation (Placement(transformation(extent={{0,-270},{20,-250}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.TimeTable y1ValCooOutIso[nCoo](
    each table=[0,0; 1,0; 1,1; 2,1],
    each timeScale=1000,
    each period=2000) if typValCooOutIso == Buildings.Templates.Components.Types.Valve.TwoWayTwoPosition
    "Cooler outlet isolation valve opening signal"
    annotation (Placement(transformation(extent={{-80,-230},{-60,-210}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.TimeTable y1PumChiWatSec[nPumChiWatSec](
    each table=[0,0; 1,0; 1,1; 2,1],
    each timeScale=1000,
    each period=2000) "Secondary CHW pump Start/Stop signal"
    annotation (Placement(transformation(extent={{-160,10},{-140,30}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.TimeTable y1ValChiWatChiIso[nChi](
    each table=[0,0; 1,0; 1,1; 2,1],
    each timeScale=1000,
    each period=2000)
    if typValChiWatChiIso == Buildings.Templates.Components.Types.Valve.TwoWayTwoPosition
    "Chiller CHW isolation valve opening signal"
    annotation (Placement(transformation(extent={{-160,230},{-140,250}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.TimeTable y1ValConWatChiIso[nChi](
    each table=[0,0; 1,0; 1,1; 2,1],
    each timeScale=1000,
    each period=2000)
    if typValConWatChiIso == Buildings.Templates.Components.Types.Valve.TwoWayTwoPosition
    "Chiller CW isolation valve opening signal"
    annotation (Placement(transformation(extent={{-90,190},{-70,210}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.TimeTable y1PumChiWatPri[nChi](
    each table=[0,0; 1,0; 1,1; 2,1],
    each timeScale=1000,
    each period=2000) "Primary CHW pump Start/Stop signal"
    annotation (Placement(transformation(extent={{-160,70},{-140,90}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.TimeTable y1PumConWat[nChi](
    each table=[0,0; 1,0; 1,1; 2,1],
    each timeScale=1000,
    each period=2000)
    if typChi==Buildings.Templates.Components.Types.Chiller.WaterCooled
    "CW pump Start/Stop signal"
    annotation (Placement(transformation(extent={{-160,-50},{-140,-30}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant yValChiWatMinByp(
    k=1)
    "CHW minimum flow bypass valve opening signal"
    annotation (Placement(transformation(extent={{-160,110},{-140,130}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.TimeTable y1ValChiWatChiBypSer[nChi](
    each table=[0,0; 1,0; 1,1; 2,1],
    each timeScale=1000,
    each period=2000)
    "Chiller CHW bypass valve opening signal - Series chillers"
    annotation (Placement(transformation(extent={{-120,130},{-100,150}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.TimeTable y1ValChiWatChiBypPar(
    table=[0,0; 1,0; 1,1; 2,1],
    timeScale=1000,
    period=2000)
    "Chiller CHW bypass valve opening signal - Parallel chillers"
    annotation (Placement(transformation(extent={{-160,150},{-140,170}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant yValChiWatEcoByp(k=1)
    "WSE CHW bypass valve opening signal"
    annotation (Placement(transformation(extent={{-160,-110},{-140,-90}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant yPumChiWatEco(
    k=1)
    "WSE CHW HX pump speed signal"
    annotation (Placement(transformation(extent={{-130,-170},{-110,-150}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.TimeTable y1PumChiWatEco(
    table=[0,0; 1,0; 1,1; 2,1],
    timeScale=1000,
    period=2000) "WSE CHW HX pump Start/Stop signal"
    annotation (Placement(transformation(extent={{-160,-150},{-140,-130}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.TimeTable y1ValConWatEcoIso(
    table=[0,0; 1,0; 1,1; 2,1],
    timeScale=1000,
    period=2000) "WSE CW isolation valve opening signal"
    annotation (Placement(transformation(extent={{-120,-130},{-100,-110}})));
protected
  Buildings.Templates.Components.Interfaces.Bus busPumChiWatPri
    "Primary CHW pumps control bus"
    annotation (Placement(transformation(extent={{120,40},{160,80}}),
                      iconTransformation(extent={{-316,184},{-276,224}})));
  Buildings.Templates.Components.Interfaces.Bus busPumConWat
    if typChi==Buildings.Templates.Components.Types.Chiller.WaterCooled
    "CW pumps control bus" annotation (Placement(transformation(extent={{120,-60},
            {160,-20}}), iconTransformation(extent={{-316,184},{-276,224}})));
  Buildings.Templates.Components.Interfaces.Bus busPumChiWatSec
    if have_pumChiWatSec
    "Secondary CHW pumps control bus"
    annotation (Placement(transformation(
          extent={{120,0},{160,40}}),      iconTransformation(extent={{-316,184},{-276,
            224}})));
  Buildings.Templates.Components.Interfaces.Bus busValChiWatMinByp
    "CHW minimum flow bypass valve control bus" annotation (Placement(
        transformation(extent={{120,100},{160,140}}),
                                                    iconTransformation(extent={{
            -422,198},{-382,238}})));
  Buildings.Templates.Components.Interfaces.Bus busValChiWatChiBypPar
    if typArrChi==Buildings.Templates.ChilledWaterPlants.Types.ChillerArrangement.Parallel
    "Chiller CHW bypass valve control bus - Parallel chillers"
    annotation (
      Placement(transformation(extent={{120,140},{160,180}}),
                                                            iconTransformation(
          extent={{-422,198},{-382,238}})));
  Buildings.Templates.Components.Interfaces.Bus busValChiWatEcoByp
    "WSE CHW bypass valve control bus" annotation (Placement(transformation(
          extent={{120,-120},{160,-80}}),  iconTransformation(extent={{-422,198},
            {-382,238}})));
  Buildings.Templates.Components.Interfaces.Bus busPumChiWatEco
    "WSE CHW HX pump control bus" annotation (Placement(transformation(extent={{120,
            -180},{160,-140}}),     iconTransformation(extent={{-316,184},{-276,
            224}})));
  Buildings.Templates.Components.Interfaces.Bus busValConWatEcoIso
    "WSE CW isolation valve control bus" annotation (Placement(transformation(
          extent={{120,-140},{160,-100}}), iconTransformation(extent={{-422,198},
            {-382,238}})));
equation
  /* 
  HACK: The following clauses should be removed at translation if `not have_pumChiWatSec` 
  but Dymola fails to do so.
  Hence, explicit `if then` statements are used.
  */
  if have_pumChiWatSec then
    connect(yPumChiWatSec.y, busPumChiWatSec.y)
      annotation (Line(points={{-108,0},{140,0},{140,20}},  color={0,0,127}));
    connect(busPumChiWatSec, bus.pumChiWatSec) annotation (Line(
        points={{140,20},{200,20},{200,0},{260,0}},
        color={255,204,51},
        thickness=0.5));
    connect(y1PumChiWatSec.y[1], busPumChiWatSec.y1)
      annotation (Line(points={{-138,20},{140,20}},     color={255,0,255}));
  end if;
  connect(yPumChiWatPri.y, busPumChiWatPri.y)
    annotation (Line(points={{-108,60},{140,60}}, color={0,0,127}));
  connect(busPumChiWatPri, bus.pumChiWatPri) annotation (Line(
      points={{140,60},{170,60},{170,0},{260,0}},
      color={255,204,51},
      thickness=0.5));

  connect(yPumConWat.y, busPumConWat.y)
    annotation (Line(points={{-108,-60},{140,-60},{140,-40}},color={0,0,127}));
  connect(busPumConWat, bus.pumConWat) annotation (Line(
      points={{140,-40},{160,-40},{160,0},{260,0}},
      color={255,204,51},
      thickness=0.5));
  connect(y1PumChiWatPri.y[1], busPumChiWatPri.y1) annotation (Line(points={{-138,80},
          {140,80},{140,60}},        color={255,0,255}));
  connect(y1PumConWat.y[1], busPumConWat.y1) annotation (Line(points={{-138,-40},
          {140,-40}},                    color={255,0,255}));
  connect(yValChiWatMinByp.y, busValChiWatMinByp.y)
    annotation (Line(points={{-138,120},{140,120}}, color={0,0,127}));
  connect(y1ValChiWatChiBypSer.y[1], busValChiWatChiByp.y1) annotation (Line(
        points={{-98,140},{160,140},{160,80},{220,80}}, color={255,0,255}));
  connect(busValChiWatChiBypPar, bus.valChiWatChiByp) annotation (Line(
      points={{140,160},{186,160},{186,0},{260,0}},
      color={255,204,51},
      thickness=0.5));
  connect(y1ValChiWatChiBypPar.y[1], busValChiWatChiBypPar.y1)
    annotation (Line(points={{-138,160},{140,160}},
                                                  color={255,0,255}));
  connect(busValChiWatMinByp, bus.valChiWatMinByp) annotation (Line(
      points={{140,120},{180,120},{180,0},{260,0}},
      color={255,204,51},
      thickness=0.5));
  connect(yPumChiWatEco.y, busPumChiWatEco.y) annotation (Line(points={{-108,
          -160},{140,-160}},      color={0,0,127}));
  connect(y1PumChiWatEco.y[1], busPumChiWatEco.y1)
    annotation (Line(points={{-138,-140},{140,-140},{140,-160}},
                                                      color={255,0,255}));
  connect(yValChiWatEcoByp.y, busValChiWatEcoByp.y)
    annotation (Line(points={{-138,-100},{140,-100}}, color={0,0,127}));
  connect(busPumChiWatEco, bus.pumChiWatEco) annotation (Line(
      points={{140,-160},{190,-160},{190,0},{260,0}},
      color={255,204,51},
      thickness=0.5));
  connect(busValChiWatEcoByp, bus.valChiWatEcoByp) annotation (Line(
      points={{140,-100},{170,-100},{170,0},{260,0}},
      color={255,204,51},
      thickness=0.5));
  connect(busValConWatEcoIso, bus.valConWatEcoIso) annotation (Line(
      points={{140,-120},{180,-120},{180,0},{260,0}},
      color={255,204,51},
      thickness=0.5));
  connect(y1ValConWatEcoIso.y[1], busValConWatEcoIso.y1) annotation (Line(
        points={{-98,-120},{140,-120}},                     color={255,0,255}));
  connect(yPumConWatDed.y, busPumConWat.y) annotation (Line(points={{-78,-80},{
          140,-80},{140,-40}},    color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(yPumChiWatPriDed.y, busPumChiWatPri.y) annotation (Line(points={{-78,40},
          {140,40},{140,60}},        color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(y1Chi.y[1], bus.y1Chi) annotation (Line(points={{-138,280},{256,280},
          {256,0},{260,0}}, color={255,0,255}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(TChiWatSupSet.y, bus.TChiWatSupSet) annotation (Line(points={{-78,260},
          {254,260},{254,0},{260,0}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(y1Coo.y[1], bus.y1Coo) annotation (Line(points={{22,-260},{254,-260},
          {254,0},{260,0}},color={255,0,255}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(yCoo.y, bus.yCoo) annotation (Line(points={{62,-280},{256,-280},{256,
          0},{260,0}},
                    color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(y1ValCooInlIso.y[1], busValCooInlIso.y1) annotation (Line(points={{
          -138,-180},{200,-180},{200,-140},{220,-140}}, color={255,0,255}));
  connect(y1ValCooOutIso.y[1], busValCooOutIso.y1) annotation (Line(points={{
          -58,-220},{220,-220},{220,-180}}, color={255,0,255}));
  connect(yValCooInlIso.y, busValCooInlIso.y) annotation (Line(points={{-108,
          -200},{204,-200},{204,-144},{212,-144},{212,-140},{220,-140}}, color=
          {0,0,127}));
  connect(yValCooOutIso.y, busValCooOutIso.y) annotation (Line(points={{-28,
          -240},{224,-240},{224,-180},{220,-180}}, color={0,0,127}));
  connect(y1ValChiWatChiIso.y[1], busValChiWatChiIso.y1) annotation (Line(
        points={{-138,240},{200,240},{200,160},{220,160}}, color={255,0,255}));
  connect(yValChiWatChiIso.y, busValChiWatChiIso.y) annotation (Line(points={{
          -108,220},{196,220},{196,160},{220,160}}, color={0,0,127}));
  connect(y1ValConWatChiIso.y[1], busValConWatChiIso.y1) annotation (Line(
        points={{-68,200},{194,200},{194,120},{220,120}}, color={255,0,255}));
  connect(yValConWatChiIso.y, busValConWatChiIso.y) annotation (Line(points={{
          -38,180},{192,180},{192,120},{220,120}}, color={0,0,127}));
  annotation (
  defaultComponentName="ctr",
  Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end OpenLoop;