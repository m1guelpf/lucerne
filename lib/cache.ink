` HTTP request cache `

std := load('../vendor/std')

CacheDelay := 15 `` seconds

new := () => (
	store := {}

	getTimestamp := key => store.(key) :: {
		() -> 0
		_ -> store.(key).timestamp
	}

	` cache.new returns a single callback that is the "getter" for the cache.

		key: the key on which the value is cached
		fetch: an async function to fetch the new value, should that be needed
		cb: callback to be invoked by the cache with the cached or new value `
	get := (key, fetch, cb) => time() - getTimestamp(key) < CacheDelay :: {
		true -> cb(store.(key).record)
		_ -> fetch(resp => (
			store.(key) := {
				timestamp: time()
				record: resp
			}
			cb(resp)
		))
	}
)
