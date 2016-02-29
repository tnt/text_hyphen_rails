require 'rails_helper'

RSpec.describe ActiveJobStore::JobRepository, type: :model do
  # subject { build(:test_event_class) }
  let(:instance) { TestJob.new schnurps: 'möhre' }
  let(:instance2) { TestJob.new schnurps: 'salat' }

  describe '.versions' do
    it 'accepts an arbitrary amount of arguments of arbitrary type' do
      expect { described_class.versions 'test', 1, :test2 }.not_to raise_error
    end

    it 'returns an Array' do
      expect(described_class.versions 'test').to be_a Array
    end

    it 'returns the highest version for existing signatures' do
      described_class.register 'test', 1
      described_class.register 'test', 3
      expect(described_class.versions('test').first).to eq 3
    end

    it 'returns a version only for registered labels' do
      expect(described_class.versions('test').first).to be_nil
    end
  end

  describe '.register' do
    it 'creates a database record' do
      expect { described_class.register 'test', 0 }.to change(ActiveJobStore::Job, :count).from(0).to(1)
    end

    it 'returns the job instance' do
      expect(described_class.register 'test', 0).to be_a ActiveJobStore::Job
    end

    it 'accepts almost anything as signature' do
      expect { described_class.register 'test', 0 }.not_to raise_error
      expect { described_class.register 1, 0 }.not_to raise_error
      expect { described_class.register :test2, 0 }.not_to raise_error
    end

    it 'raises an error on attempts to register already registered signatures' do
      expect { described_class.register 'test', 0 }.not_to raise_error
      expect { described_class.register 'test', 0 }.to raise_error(ActiveJobStore::JobRepository::AlreadyRegistered)
    end

    it 'raises an error on attempts to register already registered signatures with the same version than the current' do
      expect { described_class.register 'test', 5 }.not_to raise_error
      expect { described_class.register 'test', 5 }.to raise_error(ActiveJobStore::JobRepository::AlreadyRegistered)
    end

    it 'raises an error on attempts to register already registered signatures with versions smaller than the current' do
      expect { described_class.register 'test', 5 }.not_to raise_error
      expect { described_class.register 'test', 3 }.to raise_error(ActiveJobStore::JobRepository::AlreadyRegistered)
    end

    it 'creates a database record with a version higher than the current' do
      expect { described_class.register 'test', 5 }.not_to raise_error
      expect { described_class.register 'test', 6 }.to change(ActiveJobStore::Job, :count).from(1).to(2)
    end
  end

  describe '.error' do
    it 'returns true for registered labels' do
      js_record = described_class.register(instance.signature, 0)
      js_record.working!
      expect(described_class.error(instance.signature, 0)).to eq(true)
    end

    it 'raises an error when called for not previously registered labels' do
      expect { described_class.error(instance.signature, 0) }.to raise_error(ActiveRecord::RecordNotFound)
    end

    it 'updates the corresp. ActiveJobStore::Job instances status for a signature to \'failed\'' do
      js_record = described_class.register(instance.signature, 0)
      expect(js_record.status).to eq('pending')
      js_record.working!
      described_class.error(instance.signature, 0)
      js_record.reload
      expect(js_record.status).to eq('failed')
    end
  end

  describe '.succeed' do
    it 'returns true for registered labels' do
      js_record = described_class.register(instance.signature, 0)
      js_record.working!
      expect(described_class.succeed(instance.signature, 0)).to eq(true)
    end

    it 'raises an error when called for not previously registered labels' do
      expect { described_class.succeed(instance.signature, 0) }.to raise_error(ActiveRecord::RecordNotFound)
    end

    it 'updates the corresp. ActiveJobStore::Job instances status for a signature to \'success\'' do
      js_record = described_class.register(instance.signature, 0)
      expect(js_record.status).to eq('pending')
      js_record.working!
      described_class.succeed(instance.signature, 0)
      js_record.reload
      expect(js_record.status).to eq('successful')
    end
  end

  describe '.work' do
    it 'sets the status to working' do
      js_record = described_class.register(instance.signature, 0)
      expect(js_record.status).to eq('pending')
      described_class.work(instance.signature, 0)
      js_record.reload
      expect(js_record.status).to eq('working')
    end

    it 'succeeds when status is "pending"' do
      described_class.register(instance.signature, 0).pending!
      expect { described_class.work(instance.signature, 0) }.not_to raise_error
    end

    it 'succeeds when status is "failed"' do
      described_class.register(instance.signature, 0).failed!
      expect { described_class.work(instance.signature, 0) }.not_to raise_error
    end

    it 'raises an exception when status is "successful"' do
      described_class.register(instance.signature, 0).successful!
      expect { described_class.work(instance.signature, 0) }.to raise_error(described_class::InvalidStateTransition)
    end

    it 'raises an exception when status is "working"' do
      described_class.register(instance.signature, 0).working!
      expect { described_class.work(instance.signature, 0) }.to raise_error(described_class::InvalidStateTransition)
    end

    it 'raises an exception when status is "aborted"' do
      described_class.register(instance.signature, 0).aborted!
      expect { described_class.work(instance.signature, 0) }.to raise_error(described_class::InvalidStateTransition)
    end
  end

  describe '.abort' do
    it 'sets the status to aborted' do
      js_record = described_class.register(instance.signature, 0)
      expect(js_record.status).not_to eq('aborted')
      described_class.abort(instance.signature, 0)
      js_record.reload
      expect(js_record.status).to eq('aborted')
    end

    it 'succeeds when status is "pending"' do
      described_class.register(instance.signature, 0).pending!
      expect { described_class.abort(instance.signature, 0) }.not_to raise_error
    end

    it 'succeeds when status is "failed"' do
      described_class.register(instance.signature, 0).failed!
      expect { described_class.abort(instance.signature, 0) }.not_to raise_error
    end

    it 'raises an exception when status is "successful"' do
      described_class.register(instance.signature, 0).successful!
      expect { described_class.abort(instance.signature, 0) }.to raise_error(described_class::InvalidStateTransition)
    end

    it 'raises an exception when status is "working"' do
      described_class.register(instance.signature, 0).working!
      expect { described_class.abort(instance.signature, 0) }.to raise_error(described_class::InvalidStateTransition)
    end

    it 'raises an exception when status is "aborted"' do
      described_class.register(instance.signature, 0).aborted!
      expect { described_class.abort(instance.signature, 0) }.to raise_error(described_class::InvalidStateTransition)
    end
  end

  describe '.remove' do
    it 'removes an aborted job' do
      js_record = described_class.register(instance.signature, 0)
      described_class.abort(instance.signature, 0)
      described_class.remove(instance.signature, 0)
      expect { js_record.reload }.to raise_error(ActiveRecord::RecordNotFound)
    end

    it 'raises an exception when status is "pending"' do
      described_class.register(instance.signature, 0).pending!
      expect { described_class.remove(instance.signature, 0) }.to raise_error(described_class::InvalidStateTransition)
    end

    it 'raises an exception when status is "failed"' do
      described_class.register(instance.signature, 0).failed!
      expect { described_class.remove(instance.signature, 0) }.to raise_error(described_class::InvalidStateTransition)
    end

    it 'raises an exception when status is "successful"' do
      described_class.register(instance.signature, 0).successful!
      expect { described_class.remove(instance.signature, 0) }.to raise_error(described_class::InvalidStateTransition)
    end

    it 'raises an exception when status is "working"' do
      described_class.register(instance.signature, 0).working!
      expect { described_class.remove(instance.signature, 0) }.to raise_error(described_class::InvalidStateTransition)
    end

    it 'succeeds when status is "aborted"' do
      described_class.register(instance.signature, 0).aborted!
      expect { described_class.remove(instance.signature, 0) }.not_to raise_error
    end
  end
end
