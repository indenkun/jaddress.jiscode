#' Search for JIS codes by Address
#'
#' @description
#' This function allows you to get the organization code by entering an address that includes the name of the prefecture and city.
#' The address must be in Japanese, and the name of the prefecture, city, town, or village must be in kanji.
#' The name of the prefecture must be complete, such as "Akita-ken", and the name of the municipality must end with a string, such as "Akita-shi".
#'
#' @param x Input vector. address strings.
#' @param jis Selecting "city" will output the group code up to the city, and selecting "pref" will output the group code up to the prefecture.
#' @param check.digit a logical value. If set to TRUE, the 6th digit check digit will be displayed.
#'
#' @return a charactor.
#'
#' @details
#' The data for the organization code comes from the data published by the Ministry of Internal Affairs and Communications.
#' Source: Ministry of Internal Affairs and Communications website, National Local Government Code (https://www.soumu.go.jp/denshijiti/code.html) "Prefectural Code and Municipal Code" (updated on May 1, 2019)
#' The copyright of the data published by the Ministry of Internal Affairs and Communications (MIC) on its website belongs to the Ministry of Internal Affairs and Communications (MIC), but processing and redistribution are permitted within a certain range.
#' For details, please refer to the web page of the Ministry of Internal Affairs and Communications.
#'
#' @export

jaddress_jiscode <- function(x, jis = c("city", "pref"), check.digit = FALSE){
  jis <- match.arg(jis)
  if(!purrr::is_logical(check.digit, n = 1)){
    warning("Only logical type of 'check.digit' is accepted.")
    return(NA)
  }

  purrr::map2_chr(x, jis, function(x, jis, check.digit){
    pref_name <- zipangu::separate_address(x)$prefecture
    city_name <- zipangu::separate_address(x)$city

    if(is.na(pref_name) && is.na(city_name)){
      warning("The address is not in a searchable form for jis codes.")
      return(NA)
    }

    if(!is.na(city_name)) japanJIS <- japanJIS[!is.na(japanJIS$city),]

    if(!is.na(pref_name) && !is.na(city_name)){
      jis_code <- japanJIS$jis_code[(japanJIS$prefecture == pref_name & japanJIS$city == city_name)]
      if(purrr::is_empty(jis_code)){
        city_list <- japanJIS[japanJIS$prefecture == pref_name,]
        jis_code <- city_list$jis_code[stringr::str_detect(city_name, city_list$city)]
      }
    }else if(is.na(pref_name)){
      jis_code <- japanJIS$jis_code[japanJIS$city == city_name]
      if(purrr::is_empty(jis_code)){
        if(sum(stringr::str_detect(city_name, japanJIS$city)) == 1) jis_code <- japanJIS$jis_code[stringr::str_detect(city_name, japanJIS$city)]
        else{
          warning("It seems that the address was not narrowed down to a single jis code or was not in a searchable format.")
          return(NA)
        }
      }
    }else if(is.na(city_name)){
      jis_code <- japanJIS$jis_code[min(which(japanJIS$prefecture == pref_name))]
      if(purrr::is_empty(jis_code)){
        if(sum(stringr::str_detect(pref_name, japanJIS$prefecture)) >= 1){
          jis_code <- japanJIS$jis_code[min(which(stringr::str_detect(pref_name, japanJIS$prefecture)))]
        }else{
          warning("It seems that the address was not narrowed down to a single jis code or was not in a searchable format.")
          return(NA)
        }
      }
    }

    if(purrr::is_empty(jis_code) || length(jis_code) != 1){
      warning("It seems that the address was not narrowed down to a single jis code or was not in a searchable format.")
      return(NA)
    }

    if(!check.digit) jis_code <- stringr::str_sub(jis_code, 1, 5)

    if(jis == "city") jis_code
    else if(jis == "pref") stringr::str_sub(jis_code, 1, 2)
  }, check.digit = check.digit)
}
