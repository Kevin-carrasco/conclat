pacman::p_load(formr, dplyr, purrr, writexl)

formr_connect("kevin.carrasco@ug.uchile.cl", "k959371343") #use API to connect to formr
conclat_v1 <- formr_raw_results("v1conclat")
conclat_v2 <- formr_raw_results("v2conclat")


conclat <- reduce(
  list(
    select(conclat_v1, -modified, -ended, -expired), 
    select(conclat_v2, -session_id, -study_id, -iteration, -created, -ended, -expired)
  ),
  left_join,
  by = "session"
)

participantes <- conclat[complete.cases(conclat[, c("session", "start_01", "nombre_encuestador", "a02")]), ]

participantes <- participantes %>% filter(!correo %in% c("elbert.rodolfo@gmail.com", "Elbert.rodolfo@gmail.com", "prueba", "pedrodbclaro@gmail.com"))
participantes <- participantes %>% filter(!nombre_encuestador %in% c("PRUEBA", "Prueba", "prueba", "prueba ", "Test", "test", "X", "0", "Bla", "prueba soria"))

writexl::write_xlsx(participantes, "conclat.xlsx")
