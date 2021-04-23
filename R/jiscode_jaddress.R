#' Search for Address by JIS codes
#'
#' @description
#' If enter a JIS code, it will output the name of the corresponding prefecture or city.
#' JIS codes are numbers or character strings composed of half-width numerals, and must have either two, five, or six digits.
#'
#' @param x a a vector. JIS codes.
#' JIS codes are numbers or character strings composed of half-width numerals, and must have either two, five, or six digits.
#' @param jis Choose \code{"all"}, \code{"city"}, or \code{"pref"}, and select the range of addresses to be printed.
#' \code{"all"} will print both the name of the prefecture and the name of the city.
#' If you select \code{"all"}, both the name of the prefecture and the name of the city will be output, but if the JIS code is two digits, only the name of the prefecture will be output.
#' \code{"city"} will output only the name of the city, and \code{"pref"} will output only the name of the prefecture.
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

jiscode_jaddress <- function(x, jis = c("all", "city", "pref")){
  jis <- match.arg(jis)

  purrr::map2_chr(x, jis, function(x, jis){
    if(!(stringr::str_length(x) %in% c(2, 5, 6))) {
      warning("Please enter the JIS code as a 2-digit, 5-digit, or 6-digit value.")
      return(NA)
    }

    if(!stringr::str_detect(x, pattern = "[0123456789]")){
      warning("JIS codes are only accepted if they consist of only half-width numbers.")
      return(NA)
    }

    if(stringr::str_length(x) == 2){
      if(!is.infinite(suppressWarnings(min(which(stringr::str_detect(japanJIS$jis_code, pattern = stringr::str_c("^", x))))))){
        pref_name <- japanJIS$prefecture[min(which(stringr::str_detect(japanJIS$jis_code, pattern = stringr::str_c("^", x))))]
        city_name <- NA
      }else{
        warning("The JIS code entered is not a JIS code that can be processed.")
        return(NA)
      }
    }else{
      if(any(stringr::str_detect(japanJIS$jis_code, pattern = stringr::str_c("^", x)))){
        pref_name <- japanJIS$prefecture[(stringr::str_detect(japanJIS$jis_code, pattern = stringr::str_c("^", x)))]
        city_name <- japanJIS$city[(stringr::str_detect(japanJIS$jis_code, pattern = stringr::str_c("^", x)))]
      }else{
        warning("The JIS code entered is not a JIS code that can be processed.")
        return(NA)
      }
    }

    if(jis == "all"){
      if(!is.na(city_name)) stringr::str_c(pref_name, city_name)
      else pref_name
    }else if(jis == "city"){
      city_name
    }else if(jis == "pref"){
      pref_name
    }
  })
}
