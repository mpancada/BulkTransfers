class Numeric
    def cents_to_eur
        self / 100
    end

    def eur_to_cents
        self * 100
    end

    def is_currency(currency_name)
        # Should convert self to EUR value assuming its currency_name, so we can make math easily between different currencies
        # Usage example
        # 1000.is_currency("JPY") + 20.is_currency(USD) = 26.85 # EUR

        # NOTE: Need to find an API to get current rates, since I dont want use my time for that it will just return self
        self
    end
end
