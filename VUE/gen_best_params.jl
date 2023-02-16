"""
the program used to generate best parameters
"""

using JLD

function main(;res_f::String="./res/",subjs::AbstractVector{<:AbstractString}=["s01","s02","s03","s06","s08","s09","s10","s12","s13","s15","sall"],data_type::String="oa")
    
    # oa:k,R,EV_UR,nondt,f | std: k,a,nondt (old time)
    # oa:k,R,EV_UR,nondt,T0gisma,f | std: k,a,nondt T0sigma (new time)

    postfix=""
    if data_type=="std" 
        postfix="_std" 
    end
    for (i,subj) in enumerate(subjs)
        if subj=="sall" && data_type=="std" continue end
        res_folder="$(res_f)$subj"
        println("----------------subject: $subj-------------")
        res_files=filter(x->occursin(Regex("^res$(postfix)_[0-9]+.jld"),x), readdir("$(res_folder)"))
        bfile="$res_folder/bps$(postfix).jld"

        # minimum LL
        min_ll=Inf;trig=false;local res;local best_res;local best_params
        if data_type=="std"
            @show res_files[end]
            best_res=load("$res_folder/$(res_files[end])")# lastest as the best
            res=best_res
            trig=true
            min_ll=res["minimum"]
            best_params=res["params"]
        else
            for res_file in res_files
                res=load("$res_folder/$res_file")

                if res["minimum"]<min_ll
                    trig=true
                    best_res=res
                    min_ll=res["minimum"]
                    best_params=res["params"]
                end
            end
        end
        # beat the champion
        @show trig
        if trig
            println("num $i|$subj|$best_params")
        
            save(bfile,
                "best_params",best_params,
                "minimizer",best_res["minimizer"],
                "min_ll",min_ll
            )
        else
            println("subject$subj does not contain any fitted parameters")
        end
    end
end



# show best parameters
using UnPack
function show_best(;res_f::String="./res/",subjs::AbstractVector{<:AbstractString}=["s01","s02","s03","s06","s08","s09","s10","s12","s13","s15","sall"],data_type::String="oa")

    if res_f=="./res/" # old time
        if data_type=="std"
            println("num \t subj \t k,R,nondt")
        elseif data_type=="oa"
            println("num \t subj \t k,R,EV_UR,nondt,f")
        end
    else # new time
        if data_type=="std"
            println("num \t subj \t k,R,nondt,T0sigma")
        elseif data_type=="oa"
            println("num \t subj \t k,R,EV_UR,nondt,T0sigma,f")
        elseif data_type=="dropout"
            println("num \t subj \t k,b_intercept,b_slope,dropout_μ,dropout_σ,nondt")
        elseif data_type=="2d3b"
            println("num \t subj \t k1,k2,b1_intercept,b1_slope,b2,nondt")
        end
    end

    for (i,subj) in enumerate(subjs)
        res_folder="$res_f$subj"
        postfix=data_type=="std" ? "_std" : ""  
        bfile=load("$res_folder/bps$postfix.jld")
        @unpack best_params,min_ll=bfile
        println("$i \t $subj \t $best_params \t $min_ll")
    end
end

# thefolder="./res_race2D3B/";data_type="2d3b"
thefolder="./res/";data_type=""
main(;res_f=thefolder,subjs=["s01","s02","s03","s06","s08","s09","s10","s12","s13","s15","sall"],data_type=data_type)
show_best(;res_f=thefolder,subjs=["s01","s02","s03","s06","s08","s09","s10","s12","s13","s15","sall"],data_type=data_type)
