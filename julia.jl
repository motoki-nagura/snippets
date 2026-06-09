#==================================
      Snippets for Julia {{{
===================================#

#  Last element
array[end]

#  Make an array from two vectors
array = vector1 * transpose(vector2)
#   julia> vector1 = [1, 2, 3]
#   julia> vector2 = [4, 5, 6, 7]
#   julia> array = vector1 * transpose(vector2)
#      3×4 Matrix{Int64}:
#        4   5   6   7
#        8  10  12  14
#       12  15  18  21
#   julia> size(array)
#      (3, 4)

#  Conditional Substitution
var(x) = @. ifelse( x > 5.,  x .^2, 0. )
            #   Substitute x**2 if x > 5. Substitute 0 if not.

#  "dot call"
@. expr
#Convert every function call or operator in expr into a "dot call" (e.g. convert f(x) to f.(x)), and convert every assignment in expr to a "dot assignment" (e.g. convert += to .+=).

#  Increasing array (real numbers)
arr = range(start, stop, length)

#  Increasing array (integers)
arr = collect(start:step:stop)

#  For loop
for a in A
    # Do something with the element a
end

for i in eachindex(A)
    # Do something with i and/or A[i]
end

for (i,element) in enumerate(list)
    # Do something
end

#  Find the index at which the array element is closest to a specific value
index = argmin(abs.(array .- target_value))

#  Find the indices of elements within the range
indices = findall(x -> range_start <= x <= range_end, array)

#  Find the indices of "array1" at which array1[i] == one of the elements of "array2"
indices = findall(x -> array1[x] in array2, 1:length(array1))

# Check that a, b, and c are all equal to the same value
if all(x -> x == 5, [a, b, c])
    #(do something)
end

#  Reduce the dimension of an array
τˣ_xt = @views τˣ[:,jmid,:]

#  Mutable structure
mutable struct array_field
    var::Array{Float64, 3}
    grid
end

uvel = array_field(u_in, "fca")  #  u_in[1:100,1:50,1:200], say

#----------------------------------------------------
#  functions
#----------------------------------------------------
#         ---------------->   In functions.jl
module ExternalFunctions
#using NetCDF    #  read in packages if necessary
export Function_Name

function Function_Name(input_argument)
    #  Do something
    return Results
end    #   end of the function
end    #   end of the module
#         <----------------   In functions.jl

#         ----------------->   In main.jl
include("./functions.jl") #   Wave Initial Conditions
using .ExternalFunctions
result = Function_Name(input_argument)
#         <----------------   In main.jl

#}}}

#===================================
             Printf {{{
===================================#

using Printf

"Zonal Velocity at " * string(Int64(lev[1])) * " m"

"Meridional mode is " * @sprintf("%1d",mmode)

println("array = ",join([@sprintf("%.2e", x) for x in array], ", "))

#}}}

#===================================
            Statistics {{{
===================================#

using Statistics

#  Average

avg = mean(var, dims=(1,2))

#}}}

#===================================
            julia-vim   {{{
===================================#

#  How to type in julia-vim
\alpha<tab> -> α
x\_1<tab> -> x₁

#}}}
 
#===================================
              NCDatasets     {{{
===================================#

using NCDatasets

# ----------------   Read In  ----------------
#
# The mode "r" stands for read-only. The mode "r" is the default mode and the parameter can be omitted.
ds = NCDataset("file.nc","r")
v = ds["temperature"]
close(ds)

# load a subset
subdata = v[10:30,30:5:end]

# load all data
data = v[:,:]

# load all data ignoring attributes like scale_factor, add_offset, _FillValue and time units
data2 = v.var[:,:];

# load an attribute
unit = v.attrib["units"]
close(ds)

# ----------------   Write Out  ----------------

using DataStructures: OrderedDict
# This creates a new NetCDF file called file.nc.
# The mode "c" stands for creating a new file (clobber)
ds = NCDataset("file.nc","c")

# Define the dimension "lon" and "lat" with the size 100 and 110 resp.
defDim(ds,"lon",100)
defDim(ds,"lat",110)

# Define a global attribute
ds.attrib["title"] = "this is a test file"

# Define the variables temperature with the attribute units
v = defVar(ds,"temperature",Float32,("lon","lat"), attrib = OrderedDict(
    "units" => "degree Celsius",
    "scale_factor" => 10,
))

# add additional attributes
v.attrib["comments"] = "this is a string attribute with Unicode Ω ∈ ∑ ∫ f(x) dx"

# Generate some example data
data = [Float32(i+j) for i = 1:100, j = 1:110];

# write a single column
v[:,1] = data[:,1];

# write a the complete data set
v[:,:] = data;

# It is also possible to create the dimensions, define the variable and set its value with a single call to defVar:
v = defVar(ds,"temperature",data,("lon","lat"))
# v = defVar(ds,"temperature",data,("lon",))      #  "," is necessary after "lon"

close(ds)

#}}}

#===================================
              NetCDF     {{{
===================================#
using NetCDF

#  Read from a NetCDF file
ts = ncread(file_name,"u",start=[180,45,1], count=[1,1,-1])
#       count = -1 is for reading all values
#       Note that the dimensions are in the order of [{lon},{lat},{lev},{time}]

#  Read dates from a NetCDF file
using Dates
tvec = Dates.DateTime(2010,1,1)+Dates.Hour.(ncread(file_name,"time"))

#  Read attributes
var_attr = ncgetatt(file_name,"var","long_name")
glb_attr = ncgetatt(file_name,"Global","long_name")

#  Write to a NetCDF file
var_atts = Dict("longname" => "Output Variable", "units" => "m/s")
lon_atts = Dict("longname" => "Longitude", "units" => "degrees east")
lat_atts = Dict("longname" => "Latitude",  "units" => "degrees north")
tim_atts = Dict("longname" => "Time",      "units" => "hours since 2010-1-1 00:00:00");

file_name = "./out.nc"
isfile(file_name) && rm(file_name)
nccreate(file_name,"var1","lon",lon,lon_atts,"lat",lat,lat_atts,"time",time,tim_atts,atts=var_atts);
nccreate(file_name,"var2","lon",lon,lon_atts,"lat",lat,lat_atts,"time",time,tim_atts,atts=var_atts);
ncwrite(var1,file_name,"var1");
ncwrite(var2,file_name,"var2");
ncclose(file_name)

#}}}

#===============================================
                 PyPlot    {{{
================================================#

using PyPlot
using PyCall
plt = pyimport("matplotlib.pyplot")

#                 Multipage option
@pyimport matplotlib.backends.backend_pdf as pdf
pdf_file = pdf.PdfPages("fig.pdf")

# ------------
nrows, ncols = 2, 2
fig, axs0 = subplots(nrows, ncols, figsize=(8, 8))
axs = vec(permutedims(axs0, [2, 1]))    #   convert to a 1d array

axs[1].plot(lon, var1)
axs[1].set_title("Zonal Velocity")

var2_xy = @views var2[:,:,10]
cnt11 = axs[2].contourf(x, y, transpose(real(var_xy)), cmap="jet")
colorbar(cnt11, orientation="horizontal")

for ax in axs
    ax.set_xlabel("Latitude")
    ax.set(xlabel=L"-(s_a c)^{-1}")     #   Latex symbol
end

#for i in 1:nrows, j in 1:ncols
#    ax = axs[i, j]  # Get the subplot at position (i, j)
#    ax.set_xlabel("Latitude")
#end

fig.delaxes(axs[3])

tight_layout()
gcf()[:savefig](pdf_file, format="pdf") # Save the current figure to a new page in the PDF
close()                                 # Close the current figure

# ------------

pdf_file[:close]()   #  Close the file

# ------------
# ------------

tight_layout()
savefig("plot.pdf")    #   For a single PDF page

#}}}

#===============================================
             DSP (digital filtering)   {{{
================================================#

using DSP

#  Filtering
cutoff1, cutoff2, fs = 0.05, 0.2, 1.0
response = Bandpass(cutoff1, cutoff2)
design = Butterworth(5)
#filtered = filt(digitalfilter(response,design,fs=fs), signal)
filtered = filtfilt(digitalfilter(response,design,fs=fs), signal)

#  Power Spectrum (2-sided periodogram of a rectangle function with Hamming window.)
x = rect(50; padding=50);     # Rectangular pulse function
pxx = periodogram(x; onesided=false, nfft=512, fs=1000, window=hamming);
power, freq = pxx.power, pxx.freq    # (power, frequency)

#  Power Spectrum (Welch, Hanning window)
Fs, nperseg = 1.0, 512
pxx = welch_pgram(signal, nperseg; noverlap=Int64(nperseg/2), fs=Fs, window=hanning)
freq, power = pxx.freq, pxx.power
#  Using Plots
#  p2 = plot(freq[freq .> 0], power[freq .> 0], title="Power Spectrum Density", color=:black, xaxis=:log)

#}}}

#===============================================
                  Interpolations  {{{
================================================#

# ------------   One dimensional  ------------

using Interpolations

# Define the known data points
x = [1.0, 2.0, 3.0, 4.0]  # Known x values
y = [10.0, 20.0, 30.0, 40.0]  # Known y values

# Create a linear interpolation object
interp = interpolate((x,), y, Gridded(Linear()))

# Interpolate at a specific value
x_interp = 2.5
interpolated_value = interp(x_interp)

println("Interpolated value at x = $x_interp: ", interpolated_value)

#}}}

#===================================
             Glob {{{
===================================#

using Glob

files = glob("*.txt", "path/to/directory")  # Lists all .txt files
println(files)

#}}}

#===================================
       SpecialPolynomials {{{
===================================#

julia> using Polynomials,  SpecialPolynomials

julia> x = variable(Polynomial{Rational{Int}})
Polynomial(x)

julia> [basis(Hermite, i)(x) for i in 0:5]
6-element Vector{Polynomial{Float64, :x}}:
 Polynomial(1.0)
 Polynomial(2.0*x)
 Polynomial(-2.0 + 4.0*x^2)
 Polynomial(-12.0*x + 8.0*x^3)
 Polynomial(12.0 - 48.0*x^2 + 16.0*x^4)
 Polynomial(120.0*x - 160.0*x^3 + 32.0*x^5)

julia> basis(Hermite, 0)(0.)
1.0

julia> basis(Hermite, 1)(3.)
6.0

# basis(Hermite, mode_number)(x_value)

#}}}

#===================================
              Plots {{{
===================================#

using Plots, Measures

#   Plotting separately and then combine

p1 = plot(lon, xprof, title="Zonal Profile",      xlabel="Longitude", color=:black)
p2 = plot(lat, yprof, title="Meridional Profile", xlabel="Latitude",  color=:black)
p3 = contourf(lon, time, τˣ_xt',
              title="XT Section", xlabel="Longitude", ylabel="Time (days)", cbar=false, color=:turbo)
p4 = contourf(freq, lev, power, title="PSD", xlabel="Frequency (cpd)", ylabel="Depth (m)", cbar=true,
              color=:turbo, xaxis=:log, ylimits=(300.,3500.), yflip = true,
              clims=(0,70))
plot(p1,p2,p3,p4, layout=(2,2), legend=false, top_margin=[0.2cm 0.2cm], bottom_margin=[0.5cm 0cm],
     size=(600, 600), grid=false, framestyle=:box, tick_direction=:out)
savefig("fig.pdf")

#   Use the common parameters for different panels

plot( plot(Tavg, lev, title="Temperature", xlabel="Cdeg", color=:black),
      plot(Savg, lev, title="Salinity",    xlabel="Cdeg", color=:black),
      ylabel="Depth (m)", ylimits=(0., 5000.), yflip = true,
      layout=(1,2), legend=false, top_margin=[0.2cm 0.2cm], bottom_margin=[0.5cm 0cm],
      size=(500, 500), grid=false, framestyle=:box, tick_direction=:out,
      titlefontsize=8, tickfontsize=6, guidefontsize=8 )
savefig("fig.pdf")

#  Line plot
p1 = plot(x,y1)
p1 = plot!(x,y2, linestyles=:dash)      #   overplot with dashed line

#}}}

