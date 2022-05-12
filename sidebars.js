module.exports = {
	"docs": [
		// KeyDB Docs
		{type: 'category', label: 'KeyDB Docs', collapsed: false, items: ["intro", "about", "coming-soon", "compatibility", "support"]},
		//Getting Started
		{type: 'category', label: 'Getting Started', collapsed: true, items: [
			"download",
			// KeyDB Open Source
			{type: 'category', label: 'Install/Build Instructions', collapsed: true, items:  [
				"open-source-getting-started", "ppa-deb", "rpm", "docker-basics", "build"
				]},
			// additional docs for getting started
			"first-test", "migration", "config-file", "intro-admin"
			]
		},
		{type: 'category', label: 'Benchmarking', items: ["benchmarking", "keydbdiagnostictool", "latency", "latency-monitor"]},
		{type: 'category', label: 'Server Infrastructure', items: ["active-rep", "multi-master", "replication", "cluster-spec", "cluster-man", "cluster-create", "cluster-tutorial", "sentinel", "sentinel-clients"]},
		{type: 'category', label: 'Data Types & Commands', items: ["commands", "pubsub", "transactions", "data-types-intro", "data-types", "indexes", "signals", "notifications", "pipelining", "streams-intro", "partitioning", "mass-insert"]},
		{type: 'category', label: 'Configuration', collapsed: true, items: ["persistence", "client-side-caching","lru-cache", "config-file"]},
		{type: 'category', label: 'Docker', items: [
			{type: 'link', label: 'Advanced', href: 'https://hub.docker.com/r/eqalpha/keydb'},
			"docker-active-rep", "dockerfiles"]},
		{type: 'category', label: 'Load Balancers', items: ["haproxy"]},
		{type: 'category', label: 'Security', items: ["security", "acl", "encryption"]},
		{type: 'category', label: 'Troubleshooting', items: ["debugging", "ldb"]},
		{type: 'category', label: 'Clients/APIs/Protocols', items: ["clients", "keydbcli", "protocol", "gopher"]},
		{type: 'category', label: 'More', items: ["ARM", "faq", "memory-optimization", "license"]}
	],
};

