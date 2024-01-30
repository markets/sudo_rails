class PhlexLayout < Phlex::HTML
    include Phlex::Rails::Layout

    def template
        h1 { 'Layout in Phlex' }
        yield
    end
end