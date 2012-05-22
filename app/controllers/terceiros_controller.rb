class TerceirosController < ApplicationController
  def index
    terceiros_vpsa = HTTParty.get('https://www.vpsa.com.br/vpsa/rest/externo/showroom/terceiros')
    
    @terceiros = Array.new
    
    terceiros_vpsa.each do |terceiro_vpsa|
      terceiro = Terceiro.new
      terceiro.nome = terceiro_vpsa['nome']
      terceiro.id = terceiro_vpsa['id']
      terceiro.endereco = self.endereco(terceiro_vpsa)
      @terceiros << terceiro
    end
  end
  
  def mapa
    terceiro_vpsa = HTTParty.get('https://www.vpsa.com.br/vpsa/rest/externo/showroom/terceiros/' + params[:id])
    pesquisa = Geocoder.search(self.endereco(terceiro_vpsa))
    
    @terceiro = Terceiro.new
    @terceiro.nome = terceiro_vpsa['nome']
    
    @latitude = pesquisa[0].geometry['location']['lat']
    @longitude = pesquisa[0].geometry['location']['lng']
  end
  
  def endereco(terceiro)
    return '' if !terceiro['endereco']
    endereco = terceiro['endereco']['logradouro'].to_s + ","
    endereco = endereco + terceiro['endereco']['bairro'].to_s + ','
    endereco = endereco + terceiro['endereco']['cidade'].to_s + ','
    endereco = endereco + terceiro['endereco']['pais'].to_s
    return endereco
  end
end
