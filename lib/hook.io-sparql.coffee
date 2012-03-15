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
        

class SPARQLHook extends Hook
    constructor: (options) ->
        self = this
        Hook.call(self, options)
        @client = new sparql.Client options.url

        self.on 'hook::ready', ->
            self.on '*::query', (data,fn) ->
                @queryDBPedia data , (res) ->
                    console.log res
                    fn res
        console.log "Created"


    query: (query, cb) ->
        console.log ">>Going to query"
        @client.rows  query, (err, res) ->
                cb res

    addPreffix: (key,url) ->
        @client.prefix_map[key] = url

exports.SPARQLHook = SPARQLHook
