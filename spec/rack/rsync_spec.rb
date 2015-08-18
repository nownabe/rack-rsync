require "spec_helper"
require "fileutils"

SOURCE_DIR = File.expand_path("../../source", __FILE__)
DESTINATION_DIR = File.expand_path("../../destination", __FILE__)

describe Rack::Rsync do
  describe "VERSION" do
    it "has a version number" do
      expect(Rack::Rsync::VERSION).not_to be nil
    end
  end

  describe "app" do
    let(:app_class) do
      Class.new do
        def initialize(&block)
          @block = block
        end

        def call(env)
          @block && @block.call
          [
            200,
            { "Content-Type" => "text/plain" },
            ["Hi #{env['REMOTE_USER']}"]
          ]
        end
      end
    end

    let(:lint) { Rack::Lint.new(app_class.new(&pre_process)) }
    let(:options) { ["-a"] }
    let(:pre_process) { Proc.new {} }
    let(:request) { Rack::MockRequest.new(rsync_app) }

    let(:rsync_app) do
      Rack::Rsync.new(
        lint,
        source_dir + "/",
        destination_dir + "/",
        options,
        &condition
      )
    end

    let!(:source_dir) { SOURCE_DIR }
    let!(:destination_dir) { DESTINATION_DIR }

    let!(:new_file) { File.join(source_dir, "new_file") }
    let(:pre_process) do
      Proc.new { FileUtils.touch(new_file) }
    end

    before do
      FileUtils.mkdir_p(destination_dir)
      request.get("/")
    end

    after do
      FileUtils.rm_rf(File.join(destination_dir))
    end

    shared_examples_for "default files" do
      describe "default files" do
        source_files = Dir[File.join(SOURCE_DIR, "**/*")]
        source_files.each do |source_file|
          path = source_file.sub(SOURCE_DIR, "")
          destination_file = File.join(DESTINATION_DIR, path)

          it_behaves_like "files", source_file, destination_file
        end
      end
    end

    shared_examples_for "files" do |source_file, destination_file|
      describe destination_file do
        let(:source_stat) { File::Stat.new(source_file) }
        subject { File::Stat.new(destination_file) }
        it "exists" do
          expect(File.exist?(destination_file)).to be_truthy
        end
        its(:size) { is_expected.to eq source_stat.size }
        its(:uid) { is_expected.to eq source_stat.uid }
        its(:gid) { is_expected.to eq source_stat.gid }
        its(:mode) { is_expected.to eq source_stat.mode }
        its(:mtime) { is_expected.to eq source_stat.mtime } unless ENV["CI"]
      end
    end

    context "when condition is satisfied" do
      let(:condition) { Proc.new { |env| env["REQUEST_METHOD"] == "GET" } }
      after { FileUtils.rm_f(new_file) }

      it_behaves_like "default files"
      it_behaves_like(
        "files",
        File.join(SOURCE_DIR, "new_file"),
        File.join(DESTINATION_DIR, "new_file")
      )
    end

    context "when condition is not given" do
      let(:rsync_app) do
        Rack::Rsync.new(
          lint,
          source_dir + "/",
          destination_dir + "/",
          options
        )
      end

      after { FileUtils.rm_f(new_file) }

      it_behaves_like "default files"
      it_behaves_like(
        "files",
        File.join(SOURCE_DIR, "new_file"),
        File.join(DESTINATION_DIR, "new_file")
      )
    end

    context "when condition isn't satisfied" do
      let(:condition) { Proc.new { false } }
      let(:destination_file) { new_file.sub(source_dir, destination_dir) }

      describe "destination files" do
        it "should not exist" do
          expect(File.exist?(destination_file)).to be_falsey
        end
      end
    end
  end
end
