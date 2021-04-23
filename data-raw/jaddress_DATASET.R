# This is the code to create the dataset to be used in the function.
# The data for the organization code comes from the data published by the Ministry of Internal Affairs and Communications.
# Source: Ministry of Internal Affairs and Communications website, National Local Government Code (https://www.soumu.go.jp/denshijiti/code.html) "Prefectural Code and Municipal Code" (updated on May 1, 2019)
# The copyright of the data published by the Ministry of Internal Affairs and Communications (MIC) on its website belongs to the Ministry of Internal Affairs and Communications (MIC), but processing and redistribution are permitted within a certain range.
# For details, please refer to the web page of the Ministry of Internal Affairs and Communications.

data.url <- "https://www.soumu.go.jp/main_content/000730858.xlsx"
httr::GET(data.url, httr::write_disk(data.excel <- tempfile(fileext = ".xlsx")))
sheet.name <- "R1.5.1現在の団体"
japanJIS <- na.omit(readxl::read_xlsx(data.excel, sheet = sheet.name))

japanJIS <- dplyr::rename(japanJIS, jis_code = 団体コード,
                          prefecture = "都道府県名\r\n（漢字）",
                          city = "市区町村名\r\n（漢字）",)
japanJIS <- dplyr::select(japanJIS, 1:3)

rm(data.excel, data.url, sheet.name)

usethis::use_data(japanJIS, internal = TRUE, overwrite = TRUE)
