# Imports
sparql = require 'sparql'
Hook = require('hook.io').Hook

examplequery = "
        SELECT DISTINCT ?label ?abstract ?population
        WHERE { ?place rdf:type dbpedia-owl:PopulatedPlace.
                ?place foaf:name ?label.
                ?place dbpprop:population ?population.
                OPTIONAL{
                    ?place dbpedia-owl:abstract ?abstract.
                    FILTER langMatches( lang(?abstract), 'en')
                }
        } LIMIT 10"
        

class DBPediaHook extends Hook
    constructor: (options) ->
        self = this
        Hook.call(self, options)
        @client = new sparql.Client 'http://dbpedia.org/sparql'
        #Set some initial namespaces
        @client.prefix_map.dbprop = 'http://dbpedia.org/property/'
        @client.prefix_map.dbpedia = 'http://dbpedia.org/resource/'
        @client.prefix_map.rdf = 'http://www.w3.org/1999/02/22-rdf-syntax-ns#'
        @client.prefix_map.dbpedia-owl = 'http://dbpedia.org/ontology/'

        self.on 'hook::ready', ->
            self.on '*::query', (data,fn) ->
                @queryDBPedia data , (res) ->
                    console.log res
                    fn res
        console.log "Created"


    queryDBPedia: (query, cb) ->
        console.log ">>Going to query"
        @client.rows  query, (err, res) ->
                cb res

exports.DBPediaHook = DBPediaHook
