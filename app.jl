using Pkg
Pkg.activate(".")
using PlotlyJS
using Dash

plot_width = 500
plot_height = 500

sd = 1.1
layout = Layout(xaxis_title="x", yaxis_title="y",
    xaxis_range=[-sd,sd],yaxis_range=[-sd,sd], title="Lissajous Curve",
    width=plot_width, height=plot_height)

l = 1   
t = LinRange(0.0,l*2*pi,500)

function myplot(ω1,ω2)
    x = sin.(ω1*t)
    y = cos.(ω2*t)
    plot_data =[scatter(;x=x, y=y, mode="lines", name="Solution")] 
    plot(plot_data, layout)
end


mathjax = "https://cdnjs.cloudflare.com/ajax/libs/mathjax/2.7.4/MathJax.js?config=TeX-MML-AM_CHTML"
app = dash(external_scripts=[mathjax])
app.title = "DashLissajous"

curve = myplot(1,1)

curve_graph = dcc_graph(id="graph",figure=curve)

slider1 = dcc_slider(id="slider1",min=1, max=10,step=1,value=1, marks=Dict([i => ("$(i)") for i = 1:10]))

slider2 = dcc_slider(id="slider2",min=1,max=10, step=1,value=1, marks=Dict([i => ("$(i)") for i = 1:10]))

# App Layout
app.layout = html_div(
    [
        html_center(html_h1("Lissajous Curves")),
        html_center(curve_graph),
        html_center(html_div(style=Dict("width"=>"420px"),[slider1,html_p(raw"\(\omega_1\)"),slider2, html_p(raw"\(\omega_2\)")]))
    ]
)

callback!(app,Output("graph","figure"), Input("slider1","value"), Input("slider2","value")) do ω1, ω2
    global ω1_old, ω2_old
    myplot(ω1,ω2)
end

run_server(app, "0.0.0.0", debug=true)