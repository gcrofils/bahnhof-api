categories = [
    { id: 0, order: 2, slug: 'business', label: 'Business', navbar: true, class: 'home-block-border', show_featured_on_home:false },
    { id: 1, order: 99, slug: 'people', label: 'Society', show_featured_on_home:true },
    { id: 2, order: 99, slug: 'culture', label: 'Culture', show_featured_on_home:false },
    { id: 3, order: 6, slug: 'society', label: 'Society', navbar: true, show_featured_on_home:true },
    { id: 4, order: 99, slug: 'ecology', label: 'Ecology', show_featured_on_home:true },
    { id: 5, order: 99, slug: 'exhibitions', label: 'Exhibitions', show_featured_on_home:true },
    { id: 6, order: 99, slug: 'books', label: 'Books', navbar: true, show_featured_on_home:true },
    { id: 7, order: 99, slug: 'snapshots', label: 'Snapshots', show_featured_on_home:true },
    { id: 8, order: 3, slug: 'policy', label: 'Policy', class: 'home-block-reverse', show_featured_on_home:false },
    { id: 9, order: 4, slug: 'industry', label: 'Industry', navbar: true, show_featured_on_home:true },
    { id: 10, order: 5, slug: 'internet', label: 'Internet', navbar: true, show_featured_on_home:true },
    { id: 11, order: 99, slug: 'column', label: 'Column', show_featured_on_home:true },
    { id: 12, order: 7, slug: 'oneroadonebelt', label: 'One Road One Belt', class: 'home-block-reverse', navbar: true, show_featured_on_home:false },
    { id: 13, order: 99, slug: 'environment', label: 'Environment', class: 'home-block-reverse', show_featured_on_home:true },
    { id: 14, order: 99, slug: 'travel', label: 'Travel / Image', show_featured_on_home:true },
    { id: 15, order: 1, slug: 'spotlight', label: 'Spotlight', navbar: true, show_featured_on_home:true }
  ]
  
json.array! categories.sort_by{|a| a[:order] }