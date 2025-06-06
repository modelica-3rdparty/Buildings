within Buildings.Controls.OBC.CDL.Logical;
block MultiAnd
  "Logical MultiAnd, y = u[1] and u[2] and u[3] and ..."
  parameter Integer nin(min=0)=0
    "Number of input connections"
    annotation (Dialog(connectorSizing=true),HideResult=true);
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u[nin]
    "Input signals"
    annotation (Placement(transformation(extent={{-140,70},{-100,-70}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y
    "Output with true if all input signals are true"
    annotation (Placement(transformation(extent={{100,-20},{140,20}})));

protected
  Boolean uTemp[nin]
    "Temporary variable";

equation
  if size(u, 1) > 1 then
    uTemp[1]=u[1];
    for i in 2:size(u, 1) loop
      uTemp[i]=u[i] and uTemp[i-1];
    end for;
    y=uTemp[nin];
  elseif (size(u, 1) == 1) then
    uTemp[1]=u[1];
    y=uTemp[1];
  else
    y=false;
  end if;
  annotation (
    defaultComponentName="mulAnd",
    Icon(
      graphics={
        Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,0},
          fillColor={210,210,210},
          fillPattern=FillPattern.Solid,
          borderPattern=BorderPattern.Raised),
        Text(
          extent={{-144,150},{156,110}},
          textString="%name",
          textColor={0,0,255}),
        Text(
          extent={{-80,52},{56,-52}},
          textColor={0,0,0},
          textString="AND"),
        Ellipse(
          extent={{71,7},{85,-7}},
          lineColor=DynamicSelect({235,235,235},
            if y then
              {0,255,0}
            else
              {235,235,235}),
          fillColor=DynamicSelect({235,235,235},
            if y then
              {0,255,0}
            else
              {235,235,235}),
          fillPattern=FillPattern.Solid)}),
    Documentation(
      info="<html>
<p>
Block that outputs <code>y = true</code> if and only if
all elements of the input vector <code>u</code> are <code>true</code>.
If no connection to the input connector <code>u</code> is present,
the output is <code>y=false</code>.
</p>
<p>
See
<a href=\"modelica://Buildings.Controls.OBC.CDL.Logical.Validation.MultiAnd\">
Buildings.Controls.OBC.CDL.Logical.Validation.MultiAnd</a>
for an example.
</p>
</html>",
revisions="<html>
<ul>
<li>
July 26, 2021, by Jianjun Hu:<br/>
Renamed parameter <code>nu</code> to <code>nin</code>. This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2580\">Buildings, issue 2580</a>.
</li>
<li>
June 28, 2017, by Jianjun Hu:<br/>
First implementation. This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/825\">Buildings, issue 825</a>.
</li>
</ul>
</html>"));
end MultiAnd;
