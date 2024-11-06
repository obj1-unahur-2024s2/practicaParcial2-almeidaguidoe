class Personaje {
  const faccion
  //var lugarDeResidencia

  //method cambiarLocalidad(nuevaLocalidad) {lugarDeResidencia = nuevaLocalidad}

  var property fuerza
  var inteligencia
  var rol

  method potencialOfensivo() = fuerza*10 + rol.extraOfensivo()
  method esInteligente()
  method esGroso() = self.esInteligente() or rol.esGroso(self)
}

class Orco inherits Personaje(faccion = "Horda") {
  override method potencialOfensivo() = super() * 1.1
  override method esInteligente() = false
}

class Humano inherits Personaje(faccion = "Alianza") {
  override method esInteligente() = inteligencia > 50
}

//ROLES

object guerrero {
  const property extraOfensivo = 100
  method esGroso(personaje) = personaje.fuerza() > 50
}

class Cazador {
  var mascota = null
  const property extraOfensivo = mascota.potencialOfensivo()
  method esGroso(personaje) = mascota.esLongeva()
}

object brujo {
  const property extraOfensivo = 0

  method esGroso(personaje) = true
}

class Mascota {
  var fuerza
  var edad = 1
  const tieneGarras = true

  method potencialOfensivo() = fuerza * if(tieneGarras) 2 else 1
  method esLongeva() = edad > 10
}

//LOCALIDADES
class Localidad {
  const habitantes = []
  method agregarHabitante(habitante) {
    habitantes.add(habitante)
    habitante.cambiarLocalidad(self)
    }
  method defensaQueOtorga()
  var property ejercitoDefensor
  method defensas() = self.ejercitoDefensor().potencialOfensivo() + self.defensaQueOtorga()
}

class Aldea inherits Localidad{
  const tamanio
  method maximoDeHabitantes() = tamanio / 3
  override method agregarHabitante(habitante) {
    if (habitantes.size() == self.maximoDeHabitantes()) {
      throw new DomainException(message="La aldea no tiene más capacidad")
    } else {
      habitantes.add(habitante)
      habitante.cambiarLocalidad(self)
    }
  }
  override method defensaQueOtorga() = 0
}

class Ciudad inherits Localidad{
  override method defensaQueOtorga() = 300
}

//EJERCITO

class Ejercito {
  const integrantes = []
  method potencialOfensivo() = integrantes.sum({i => i.potencialOfensivo()})
  method invadir(unaLocalidad) {
    if (self.potencialOfensivo() > unaLocalidad.defensas()) {
      unaLocalidad.ejercitoDefensor(self)
    }
  }
}