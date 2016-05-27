#
#   Conexión e inserción de datos en una colección de mongodb, entre ruby y mlab
#
require "mongo"

### Declara documentos

seed_data = [
  {
    'decade' => '1970s',
    'artist' => 'Debby Boone',
    'song' => 'You Light Up My Life',
    'weeksAtOne' => 10
  },
  {
    'decade' => '1980s',
    'artist' => 'Olivia Newton-John',
    'song' => 'Physical',
    'weeksAtOne' => 10
  },
  {
    'decade' => '1990s',
    'artist' => 'Mariah Carey',
    'song' => 'One Sweet Day',
    'weeksAtOne' => 16
  }
]

### Cambiar esta dirección por la de su base de datos

uri = "mongodb://me:me@ds011943.mlab.com:11943/test-umar"

client = Mongo::Client.new(uri)

# Crea o actualiza una colección llamada songs

songs = client[:songs]

songs.create

# Inserta los documentos antes declarados

songs.insert_many(seed_data)

# Declara una busqueda de la canción "One Sweet Day"

query = { :song => 'One Sweet Day' }

songs.update_one(query, { '$set' => { :artist => 'Mariah Carey ft. Boyz II Men' } })

# Presenta los datos encontrados

cursor = songs.find({ :weeksAtOne => { '$gte' => 10 } }).sort(:decade => 1)

cursor.each{ |doc| puts "In the #{ doc['decade'] }," +
                        " #{ doc['song'] } by #{ doc['artist'] }" +
                        " topped the charts for #{ doc['weeksAtOne'] }" +
                        " straight weeks." }

# Cierra la base de datos

client.close()