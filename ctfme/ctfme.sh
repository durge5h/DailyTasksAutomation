#!bash

default_cate=("pwn" "web" "rev" "steg" "forensic" "osint")
note_dir="note_template.md"
# path =

location=""
add_cate=()
rem_cate=()
ctf_name=""
default=
show_cate=
note=
pd=$PWD

print_help() {
    printf "\nUsage: ./ctfme.sh [OPTIONS]\n\n"
    printf "Options:\n"
    printf "  -h, --h, --help                  Display this help menu\n"
    printf "  -l, --l <absolute/path>          Location for CTF directory\n"
    printf "  -a, --a, --add <categories>      Add more category/categories\n"
    printf "  -r, --r, --remove <categories>   Remove category/categories\n"
    printf "  -d, --d, --default               If you have manually set location\n"
    printf "  -n, --n, --note                  Creating note template\n"
    printf "  -s, --s, --show                  Print the default category list \n"
}

checking_arg(){
    if [ $# -eq 0 ]; then
    printf "Define arg Dumbfuck!"
    exit 1
    fi
}

creating_dirs(){
    ## mentdatory parameters
    local nte="$1"
    # echo "note is: $nte"
    ctf_name="$2"
    location="$3"
    # echo "ctf_name: ${ctf_name}, location: ${location}"
    shift 3
    local cate=("$@")

    mkdir -p "$location/$ctf_name"
    cd "$location/$ctf_name" || echo "Directory doesn't exist"
    index=0
    while [ $index -lt ${#cate[@]} ]; do
        c="${cate[$index]}"
        if [ -z "$c" ]; then
            break
        fi
        mkdir -p $c
        nt="note.md"
        for i in {1..3};do
            chl='0'$i'_'
            mkdir "$c/$chl"
            if [[ "$nte" == "true" ]]; then
                cp "$pd/$note_dir" "$c/$chl/$nt"
            fi
        done
        ((index++))
    done
}

#!bash

modify_category() {
    local -a cate=("${!1}")        # Initial array
    local -a add=("${!2}")         # Array of categories to add
    local -a rem=("${!3}")         # Array of categories to remove
    local -a new_array=("${cate[@]}")   # Create a new array for modifications

    # Add categories if specified and not already present in the array
    for new_cat in "${add[@]}"; do
        if [[ -n "$new_cat" && ! " ${new_array[@]} " =~ " $new_cat " ]]; then
            new_array+=("$new_cat")
        fi
    done

    # Remove categories if specified
    for item in "${rem[@]}"; do
        new_array=("${new_array[@]/$item}")
    done

    # Print the modified array
    echo "${new_array[@]}"

}

if [[ $# -gt 0 ]]; then
    ctf_name="$1"
    shift
else
    print_help
fi

while [[ $# -gt 0 ]];do
    case "$1" in
        "-help" | "--help" | "-h" | "--h")
            print_help
            exit 1
            ;;
        "-show" | "--show" | "-s" | "--s")
            show_cate=true
            shift
            ;;
        "-note" | "--note" | "-n" | "--n")
            note=true
            shift
            ;;
        "-default" | "--default" | "-d" | "--d")
            default=true
            shift
            ;;
        "-location" | "--location" | "-l" | "--l")
            location=$2
            shift 2
            ;;
        "-add" | "--add" | "-a" | "--a")
            add_cate=$2 #("$@")
            shift 2
            ;;
        "-remove" | "-r" | "--r")
            rem_cate=$2 #("$@")
            shift 2
            ;;
        *)
            print_help
            exit 1
            ;;
    esac
done


# Check if ctf_name and location are set (mandatory)
if [[ -n "$ctf_name" && -n "$location" ]] || [[ -n "$ctf_name" && "$default" == "true" ]]; then
    # Check if add_cate is set
    if [ -n "$add_cate" ] || [ -n "$rem_cate" ]; then
        default_cate=($(modify_category default_cate[@] add_cate[@] rem_cate[@]))
        index=0
        while [ $index -lt ${#default_cate[@]} ]; do
            echo ${default_cate[$index]}
            ((index++))
        done
    else
        # Use default_cate if no operation is specified
        modfied_array=("${default_cate[@]}")
    fi
    # Call creating_dirs with the modified array
    creating_dirs "${note:+$note}" "$ctf_name" "$location" "${default_cate[@]}"   #"
elif [[ -n "$show_cate" ]]; then
    printf "\n Deafault Categories: ${default_cate[*]}"
else
    printf "\nError: ctf_name and location must be set.\n"
    print_help
    exit 0
fi
