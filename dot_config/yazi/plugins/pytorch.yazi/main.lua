local M = {}

function M:peek(job)
    ya.err("PATH: " .. tostring(job.file.url))
    -- define the command
    local child = Command(os.getenv("HOME") .. "/.pixi/envs/yazi/bin/python")
        :arg(os.getenv("HOME") .. "/.config/yazi/scripts/pytorch.py")
        :arg(tostring(job.file.url))
        :stdout(Command.PIPED)
        :stderr(Command.PIPED)
        :spawn()

    -- ERROR 1: Command failed to start (e.g. python path wrong)
    if not child then
        ya.preview_widget(job, {
            ui.Text("ERROR: Could not spawn python command.\nCheck path: " .. os.getenv("HOME") .. "/.pixi/envs/yazi/bin/python"):area(job.area),
        })
        return
    end

    local output, err = child:wait_with_output()

    -- ERROR 2: Execution error
    if not output then
        ya.preview_widget(job, {
            ui.Text("ERROR: Child process failed: " .. tostring(err)):area(job.area),
        })
        return
    end

    -- ERROR 3: Python script crashed (show stderr)
    if output.stdout == "" and output.stderr ~= "" then
        ya.preview_widget(job, {
            ui.Text("PYTHON ERROR:\n" .. output.stderr):area(job.area),
        })
        return
    end
    
    -- SUCCESS: Show output
    ya.preview_widget(job, {
        ui.Text(output.stdout):area(job.area),
    })
end

function M:seek(job)
    -- empty
end

function M:setup(opts)
    -- empty
end
return M
