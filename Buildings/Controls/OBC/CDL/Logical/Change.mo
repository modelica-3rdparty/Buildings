within Buildings.Controls.OBC.CDL.Logical;
block Change
  "Output y is true, if the input u has a rising or falling edge (y = change(u))"
  parameter Boolean pre_u_start=false
    "Start value of pre(u) at initial time";
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u
    "Input to be monitored for a change"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y
    "Output with true when the input changes"
    annotation (Placement(transformation(extent={{100,-20},{140,20}})));

initial equation
  pre(u)=pre_u_start;

equation
  y=change(u);
  annotation (
    defaultComponentName="cha",
    Icon(
      coordinateSystem(
        preserveAspectRatio=true,
        extent={{-100,-100},{100,100}}),
      graphics={
        Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,0},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          borderPattern=BorderPattern.Raised),
        Text(
          extent={{-50,62},{50,-56}},
          textColor={0,0,0},
          textString="change"),
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
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-150,150},{150,110}},
          textString="%name",
          textColor={0,0,255})}),
    Documentation(
      info="<html>
<p>
Block that outputs <code>true</code> if the Boolean input has either a rising edge
from <code>false</code> to <code>true</code> or a falling edge from
<code>true</code> to <code>false</code>.
Otherwise the output is <code>false</code>.
</p>
</html>",
      revisions="<html>
<ul>
<li>
January 3, 2017, by Michael Wetter:<br/>
First implementation, based on the implementation of the
Modelica Standard Library.
</li>
</ul>
</html>"));
end Change;
