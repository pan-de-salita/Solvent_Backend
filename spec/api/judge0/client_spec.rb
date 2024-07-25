# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Judge0::Client, type: :request do
  let(:base_url) { 'https://judge0-ce.p.rapidapi.com' }

  let(:headers) do
    {
      'Content-Type': 'application/json',
      'x-rapidapi-key': ENV['X_RAPIDAPI_KEY'],
      'x-rapidapi-host': 'judge0-ce.p.rapidapi.com'
    }
  end

  let(:base_body) do
    {
      'status' => 200,
      'reason_phrase' => 'OK',
      'submissions_remaining' => 50,
      'data' => []
    }
  end

  let(:write_submission_body) do
    {
      'source_code' => "def add(a, b)\n  p a + b\nend\n\nadd(5, 5)",
      'language_id' => 72
    }
  end

  describe '.statuses' do
    let(:statuses_data) do
      { 'data' => [
        { 'id' => 1, 'description' => 'In Queue' },
        { 'id' => 2, 'description' => 'Processing' },
        { 'id' => 3, 'description' => 'Accepted' }
      ] }
    end

    let(:statuses_body) { base_body.merge(statuses_data).to_json }

    it 'makes a GET request to /statuses' do
      stub_request(:get, "#{base_url}/statuses")
        .with(headers:)
        .to_return(status: 200, body: statuses_body)

      response = Judge0::Client.statuses
      parsed_response_data = JSON.parse(response[:data])

      expect(response[:status]).to eq(200)
      expect(parsed_response_data['reason_phrase']).to eq('OK')
      expect(parsed_response_data['submissions_remaining']).to eq(50)
      expect(parsed_response_data['data']).to be_kind_of(Array)
      expect(parsed_response_data['data'].all? { |entry| entry.keys == %w[id description] }).to be_truthy
      expect(parsed_response_data['data'].first['description']).to eq('In Queue')
    end
  end

  describe '.languages' do
    let(:languages_data) do
      { 'data' => [
        { 'id' => 45, 'name' => 'Assembly (NASM 2.14.02)' },
        { 'id' => 46, 'name' => 'Bash (5.0.0)' },
        { 'id' => 47, 'name' => 'Basic (FBC 1.07.1)' }
      ] }
    end

    let(:languages_body) { base_body.merge(languages_data).to_json }

    it 'makes a GET request to /languages' do
      stub_request(:get, "#{base_url}/languages")
        .with(headers:)
        .to_return(status: 200, body: languages_body)

      response = Judge0::Client.languages
      parsed_response_data = JSON.parse(response[:data])

      expect(response[:status]).to eq(200)
      expect(parsed_response_data['reason_phrase']).to eq('OK')
      expect(parsed_response_data['submissions_remaining']).to eq(50)
      expect(parsed_response_data['data']).to be_kind_of(Array)
      expect(parsed_response_data['data'].all? { |entry| entry.keys == %w[id name] }).to be_truthy
      expect(parsed_response_data['data'].first['name']).to eq('Assembly (NASM 2.14.02)')
    end
  end

  describe '.all_languages' do
    let(:all_languages_data) do
      { 'data' => [
        { 'id' => 45, 'name' => 'Assembly (NASM 2.14.02)', 'is_archived' => false },
        { 'id' => 2, 'name' => 'Bash (4.0)', 'is_archived' => true },
        { 'id' => 1, 'name' => 'Bash (4.4)', 'is_archived' => true }
      ] }
    end

    let(:all_languages_body) { base_body.merge(all_languages_data).to_json }

    it 'makes a GET request to /languages/all' do
      stub_request(:get, "#{base_url}/languages/all")
        .with(headers:)
        .to_return(status: 200, body: all_languages_body)

      response = Judge0::Client.all_languages
      parsed_response_data = JSON.parse(response[:data])

      expect(response[:status]).to eq(200)
      expect(parsed_response_data['reason_phrase']).to eq('OK')
      expect(parsed_response_data['submissions_remaining']).to eq(50)
      expect(parsed_response_data['data']).to be_kind_of(Array)
      expect(parsed_response_data['data'].all? { |entry| entry.keys == %w[id name is_archived] }).to be_truthy
      expect(parsed_response_data['data'].first['is_archived']).to eq(false)
    end
  end

  context '.language' do
    describe 'when a valid language_id is provided' do
      let(:language_data) do
        { 'data' => {
          'id' => 72,
          'name' => 'Ruby (2.7.0)',
          'is_archived' => false,
          'source_file' => 'script.rb',
          'compile_cmd' => nil,
          'run_cmd' => '/usr/local/ruby-2.7.0/bin/ruby script.rb'
        } }
      end

      let(:language_body) { base_body.merge(language_data).to_json }

      it 'makes a GET request to /language/language_id' do
        stub_request(:get, "#{base_url}/languages/#{language_data['data']['id']}")
          .with(headers:)
          .to_return(status: 200, body: language_body)

        response = Judge0::Client.language(language_id: language_data['data']['id'])
        parsed_response_data = JSON.parse(response[:data])

        expect(response[:status]).to eq(200)
        expect(parsed_response_data['reason_phrase']).to eq('OK')
        expect(parsed_response_data['submissions_remaining']).to eq(50)
        expect(parsed_response_data['data']).to be_kind_of(Hash)
        expect(parsed_response_data['data'].keys).to eq(%w[id name is_archived source_file compile_cmd run_cmd])
        expect(parsed_response_data['data']['name']).to eq('Ruby (2.7.0)')
      end
    end

    describe 'when an invalid language_id is provided' do
      it 'returns a 404 error' do
        stub_request(:get, "#{base_url}/languages/123456789")
          .with(headers:)
          .to_return(status: 404, body: { status: 404, message: 'Resource not found', data: nil }.to_json)

        response = Judge0::Client.language(language_id: 123_456_789)
        parsed_response_data = response[:data]

        expect(response[:status]).to eq(404)
        expect(parsed_response_data['message']).to eq('Resource not found')
        expect(parsed_response_data['data']).to be_nil
      end
    end
  end

  describe '.write_submission' do
    it 'makes a POST request to /submissions/?base64_encoded=false&wait=false' do
      VCR.use_cassette('judge0/client_write_submission') do
        response = Judge0::Client.write_submission(
          source_code: write_submission_body['source_code'],
          language_id: write_submission_body['language_id']
        )

        expect(response[:status]).to be(201)
        expect(response[:reason_phrase]).to eq('Created')
        expect(response[:submissions_remaining] < 50).to be_truthy
        expect(response[:data]['token']).to_not be_blank
      end
    end
  end

  describe '.read_submission' do
    it 'makes a POST request to /submissions/submission_token?base64_encoded=false&fields=...' do
      VCR.use_cassette('judge0/client_read_submission') do
        write_submission_data = YAML.load_file('spec/cassettes/judge0/client_write_submission.yml')
        submission_token = JSON.parse(write_submission_data['http_interactions'].first['response']['body']['string'])['token']

        response = Judge0::Client.read_submission(token: submission_token)

        expect(response[:status]).to be(200)
        expect(response[:reason_phrase]).to eq('OK')
        expect(response[:submissions_remaining] < 50).to be_truthy
        expect(response[:data]['source_code']).to eq(write_submission_body['source_code'])
        expect(response[:data]['language_id']).to eq(write_submission_body['language_id'])
        expect(response[:data]['stdout'].chomp.to_i).to eq(10)
      end
    end
  end
end
