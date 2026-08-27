var diasPermitidos = 0
var multaPorDia = 0.0

switch tipoUsuario.lowercased() {
case "alumno":
    diasPermitidos = diasAlumno
    multaPorDia = multaAlumno

case "docente":
    diasPermitidos = diasDocente
    multaPorDia = multaDocente

case "administrador":
    diasPermitidos = diasAdministrador
    multaPorDia = multaAdministrador

default:
    print("Tipo de usuario no válido")
}