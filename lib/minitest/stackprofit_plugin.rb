require "minitest"

module Minitest
  module Stackprofit
    VERSION = "1.0.1"
  end

  @stackprof_path = nil
  @stackprof_type = :wall
  @stackprof_raw = false

  def self.plugin_stackprofit_options opts, options # :nodoc:
    opts.on "--stackprof [path]", String, "Save profiling to [path]." do |s|
      @stackprof_path = s || "stackprof.dump"
    end

    opts.on "--stackprof-type type", String, "Set profile type (default: wall)." do |s|
      @stackprof_type = s.to_sym
    end

    opts.on "--stackprof-raw", "Save raw samples (for flamegraph generation)" do |s|
      @stackprof_raw = true
    end
  end

  def self.plugin_stackprofit_init options # :nodoc:
    if @stackprof_path then
      require "stackprof"

      StackProf.start mode: @stackprof_type, out: @stackprof_path, raw: @stackprof_raw

      Minitest.after_run do
        StackProf.stop
        StackProf.results
      end
    end
  end
end
